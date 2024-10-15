//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/14/24.
//

import CodeScanner
import ConfettiSwiftUI
import SDWebImageSwiftUI
import SlidingTabView
import SwiftData
import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(NetworkMonitor.self) private var networkMonitor
    
    @State private var searchText = ""
    @State private var selectedView = 0
    @State private var showBookInfomation = false
    @State private var activateBookDeletionAlert = false
    @State private var deletedBookTitle = ""
    @State private var recentlyViewedBook: Book?
    @State private var activateSheet = false
    @State private var isEditing = false
    @State private var selectedChoice = ""
    @State private var selectedDeletionBook: Book?
    @State private var isShowingScanner = false
    @State private var isShowingTorch = false
    @State var isbnManager = FetchISBNBookInfoViewModel()
    @State private var showAddViewSheet = false
    @State private var addViewBook: VolumeInfo? = nil
    @State private var showManualFormSheet = false
    @State private var displayedImage: Image?
    @State private var hapticsManager = HapticsManager()
    @State private var isShowingOnlineSheet = false
    @State private var showBookAddingVO = false
    @State private var isBookAdded = false
    @State private var bookFailedToAdd = false
    @State private var bookFeedback = ""
    
    var books: [Book]
    
    let options = ["Ascending", "Descending"]
    
    var searchResults: [Book] {
        if searchText.isEmpty {
            return Array(books)
        } else {
            return books.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(showsIndicators: true) {
                    if !networkMonitor.isConnected {
                        VStack {
                            ContentUnavailableView("No WiFi Connection", systemImage: "wifi.slash", description: Text("Please check your WiFi connection."))
                        }
                        .frame(height: geometry.size.height)
                    } else if books.isEmpty {
                        VStack {
                            ContentUnavailableView("No Books Avaliable",
                                                   systemImage: "books.vertical",
                                                   description: Text("Click on the '+' to get started!")
                            )
                        }
                        .frame(height: geometry.size.height)
                    } else {
                        let testBook = Book(coverImage: "", title: "N/A", author: "N/A", catagory: "N/A", pages: "N/A")
                        let library = Library(books: Array(books))
                        let mostRecent = library.getMostRecentBook
                        
                        VStack(alignment: .leading) {
                            Text("Recently Added")
                                .font(.title.bold())
                                .fontDesign(.serif)
                            VStack(alignment: .leading) {
                                NavigationLink(destination: LogView(book: mostRecent ?? testBook)) {
                                    VStack {
                                        HStack {
                                            VStack {
                                                let imageString = mostRecent?.coverImage ?? "N/A"
                                                
                                                if imageString.contains("https") {
                                                    
                                                    WebImage(url: URL(string: imageString)) { image in
                                                        image
                                                            .image?.resizable()
                                                            .frame(width: 130, height: 210)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                            .shadow(color: .black.opacity(0.30), radius: 5)
                                                    }
                                                } else {
                                                    let image = imageString.toImage()
                                                    
                                                    image?
                                                        .resizable()
                                                        .frame(width: 140, height: 210)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                        .shadow(color: .black.opacity(0.30), radius: 5)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)
                                            
                                            VStack {
                                                VStack(alignment: .leading) {
                                                    Text(mostRecent?.title ?? testBook.title)
                                                        .titleModifier()
                                                    
                                                    
                                                    Text(mostRecent?.author ?? testBook.author)
                                                        .font(.system(size: 15))
                                                        .fontWeight(.medium)
                                                        .padding(.vertical, 1)
                                                    
                                                    
                                                    Text("\(mostRecent?.pages ?? testBook.pages) pages")
                                                        .font(.system(size: 14))
                                                        .padding(.vertical, 1)
                                                    
                                                    HStack {
                                                        ProgressView(value: mostRecent?.completionStatus)
                                                            .frame(width: 100)
                                                            .tint(mostRecent?.completionStatus == 1 ? .green : .blue)
                                                        let formatted = String(format: "%.1f", (mostRecent?.completionStatus ?? 0) * 100)
                                                        Text("\(formatted)%")
                                                            .font(.footnote)
                                                    }
                                                    
                                                    StarRatingView(rating: mostRecent?.starRatingSystem?.rating ?? 0.0)
                                                        .font(.headline)
                                                        .offset(y: 3)
                                                    
                                                    VStack {
                                                        Circle()
                                                            .fill(mostRecent?.completionStatus == 1 ? .green : .blue)
                                                            .frame(width: 30, height: 30)
                                                            .overlay {
                                                                Text("\(mostRecent?.getLogCount ?? 0)")
                                                                    .font(.system(size: 15))
                                                                    .fontWeight(.medium)
                                                                    .foregroundStyle(.white)
                                                            }
                                                    }
                                                    .frame(maxHeight: .infinity, alignment: .bottomLeading)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .frame(maxHeight: .infinity, alignment: .top)
                                        }
                                    }
                                    .accessibilityLabel("Recently Added: \(mostRecent?.title ?? testBook.title)")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Rectangle()
                            .fill(.gray.opacity(0.30))
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .padding()
                        
                        if recentlyViewedBook != nil && books.contains(recentlyViewedBook!) {
                            VStack(alignment: .leading) {
                                Text("Last Viewed")
                                    .font(.title.bold())
                                    .fontDesign(.serif)
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: LogView(book: recentlyViewedBook!)) {
                                        VStack {
                                            HStack {
                                                VStack {
                                                    
                                                    let imageString = recentlyViewedBook?.coverImage ?? "N/A"
                                                    
                                                    if imageString.contains("https") {
                                                        
                                                        
                                                        WebImage(url: URL(string: imageString)) { image in
                                                            image
                                                                .image?.resizable()
                                                                .frame(width: 130, height: 210)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                                .shadow(color: .black.opacity(0.30), radius: 5)
                                                        }
                                                    } else {
                                                        let image = imageString.toImage()
                                                        
                                                        image?
                                                            .resizable()
                                                            .frame(width: 140, height: 210)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                            .shadow(color: .black.opacity(0.30), radius: 5)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal)
                                                
                                                VStack {
                                                    VStack(alignment: .leading) {
                                                        Text(recentlyViewedBook?.title ?? testBook.title)
                                                            .titleModifier()
                                                        
                                                        
                                                        Text(recentlyViewedBook?.author ?? testBook.author)
                                                            .font(.system(size: 15))
                                                            .fontWeight(.medium)
                                                            .padding(.vertical, 1)
                                                        
                                                        
                                                        Text("\(recentlyViewedBook?.pages ?? testBook.pages) pages")
                                                            .font(.system(size: 14))
                                                            .padding(.vertical, 1)
                                                        
                                                        HStack {
                                                            ProgressView(value: recentlyViewedBook?.completionStatus)
                                                                .frame(width: 100)
                                                                .tint(recentlyViewedBook?.completionStatus == 1 ? .green : .blue)
                                                            let formatted = String(format: "%.1f", (recentlyViewedBook?.completionStatus ?? 0) * 100)
                                                            Text("\(formatted)%")
                                                                .font(.footnote)
                                                        }
                                                        
                                                        StarRatingView(rating: recentlyViewedBook?.starRatingSystem?.rating ?? 0.0)
                                                            .font(.headline)
                                                            .offset(y: 3)
                                                        
                                                        VStack {
                                                            Circle()
                                                                .fill(recentlyViewedBook?.completionStatus == 1 ? .green : .blue)
                                                                .frame(width: 30, height: 30)
                                                                .overlay {
                                                                    Text("\(recentlyViewedBook?.getLogCount ?? 0)")
                                                                        .font(.system(size: 15))
                                                                        .fontWeight(.medium)
                                                                        .foregroundStyle(.white)
                                                                }
                                                        }
                                                        .frame(maxHeight: .infinity, alignment: .bottomLeading)
                                                    }
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .frame(maxHeight: .infinity, alignment: .top)
                                            }
                                        }
                                        .accessibilityLabel("Last Viewed: \(recentlyViewedBook?.title ?? testBook.title)")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            
                            Rectangle()
                                .fill(.gray.opacity(0.30))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .padding()
                            
                        }
                        
                        HStack {
                            Text("Collection")
                                .collectionTextModifier()
                                .accessibilityLabel("Collection of books")
                            
                            Button(action: {
                                withAnimation(.spring(duration: 0.2, bounce: 0.1)) {
                                    isEditing.toggle()
                                }
                            }) {
                                Text("Edit")
                                    .fontDesign(.serif)
                                    .fontWeight(.semibold)
                                    .accessibilityLabel("Editing pencil to edit collection")
                                Image(systemName: "pencil")
                            }
                            .accessibilityAddTraits(.isButton)
                            .padding(.horizontal, 20)
                        }
                        
                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .top) {
                                ForEach(searchResults, id: \.self) { book in
                                    NavigationLink(destination: LogView(book: book)) {
                                        VStack {
                                            if isEditing {
                                                let imageString = book.coverImage
                                                
                                                Menu {
                                                    Button("Delete Book", systemImage: "trash", role: .destructive, action: {
                                                        selectedDeletionBook = book
                                                        activateBookDeletionAlert.toggle()
                                                    })
                                                    
                                                    ShareLink(item: URL(string: imageString)!,
                                                              message: Text("I'm currently reading \(book.title) by \(book.author). You should check it out!"),
                                                              preview: SharePreview("Check this book out!", image: Image("appLogo")),
                                                              label: {
                                                        Label("Share", systemImage: "square.and.arrow.up")
                                                    })
                                                    
                                                } label: {
                                                    Circle()
                                                        .fill(.clear)
                                                        .frame(width: 60)
                                                        .overlay {
                                                            Circle()
                                                                .fill(.gray.opacity(0.2))
                                                                .frame(width: 40)
                                                                .overlay {
                                                                    Image(systemName: "ellipsis")
                                                                }
                                                        }
                                                }
                                                
                                                
                                                Spacer()
                                                    .frame(height: 20)
                                            }
                                            
                                            let imageString = book.coverImage
                                            
                                            if imageString.contains("https") {
                                                
                                                WebImage(url: URL(string: imageString)) { image in
                                                    image
                                                        .image?.resizable()
                                                        .frame(width: 90, height: 150)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                }
                                            } else {
                                                let image = imageString.toImage()
                                                
                                                image?
                                                    .resizable()
                                                    .frame(width: 90, height: 150)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                    .shadow(color: .black.opacity(0.30), radius: 5)
                                            }
                                            
                                            HStack {
                                                ProgressView(value: book.completionStatus)
                                                    .frame(width: 40)
                                                    .tint(book.completionStatus == 1 ? .green : .blue)
                                                let formatted = String(format: "%.1f", book.completionStatus * 100)
                                                Text("\(formatted)%")
                                                    .font(.footnote)
                                            }
                                        }
                                        .accessibilityLabel("\(book.title)")
                                        
                                    }
                                    .simultaneousGesture(
                                        TapGesture().onEnded {
                                            if book != mostRecent {
                                                recentlyViewedBook = book
                                                
                                                print("")
                                                book.isMostRecentlyViewed = true
                                            }
                                        }
                                    )
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                }
                .overlay {
                    if isBookAdded {
                        VStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(.gray.opacity(0.30), lineWidth: 1)
                                .fill(.regularMaterial)
                                .frame(width: 170, height: 100)
                                .shadow(radius: 5)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            isBookAdded = false
                                        }
                                    }
                                }
                                .overlay {
                                    let library = Library(books: Array(books))
                                    let mostRecent = library.getMostRecentBook
                                    let imageString = mostRecent?.coverImage ?? "N/A"
                                        
                                    HStack {
                                        if imageString.contains("https") {
                                            AsyncImage(url: URL(string: imageString)) { image in
                                                image
                                                    .image?.resizable()
                                                    .frame(width: 50, height: 70)
                                            }
                                        } else {
                                            let image = imageString.toImage()
                                            
                                            image?
                                                .resizable()
                                                .frame(width: 50, height: 70)
                                        }
                                        
                                        VStack {
                                            Image(systemName: "book.closed.circle")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                            
                                            Text("Book Added")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -45)
                    }
                    
                    if bookFailedToAdd {
                        VStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(.gray.opacity(0.30), lineWidth: 1)
                                .fill(.regularMaterial)
                                .frame(width: 175, height: 100)
                                .shadow(radius: 5)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            bookFailedToAdd = false
                                        }
                                    }
                                }
                                .overlay {
                                    HStack {
                                        Image(systemName: "book.closed")
                                            .resizable()
                                            .frame(width: 37, height: 60)
                                        
                                        VStack {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                            
                                            Text("Book Failed To Add")
                                                .font(.footnote)
                                        }
                                    }
                                }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: -45)
                    }

                    VStack {
                        VStack {
                            Menu {
                                Button(action: {
                                    isShowingOnlineSheet.toggle()
                                }) {
                                    HStack {
                                        Text("Search Online")
                                        
                                        Image(systemName: "magnifyingglass")
                                    }
                                    .accessibilityHint("Search book online")
                                }
                                
                                Button(action: {
                                    isShowingScanner.toggle()
                                }) {
                                    HStack {
                                        Text("Scan ISBN Number")
                                        
                                        Image(systemName: "barcode.viewfinder")
                                    }
                                    .accessibilityHint("Scan isbn number")
                                }
                                
                                Button(action: {
                                    showManualFormSheet.toggle()
                                }) {
                                    HStack {
                                        Text("Manually Add Book")
                                        
                                        Image(systemName: "document")
                                    }
                                    .accessibilityHint("Manually add book")
                                }
                                
                            } label: {
                                Circle()
                                    .fill(.complement)
                                    .frame(width: 60, height: 60)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 17, height: 17, alignment: .center)
                                            .foregroundStyle(.white)
                                    }
                                    .accessibilityLabel("Ways to add a book")
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottomTrailing)
                        .accessibilityAddTraits(.isButton)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 10)
                    .padding(.vertical, -20)
                }
            }
            .padding(.bottom, 30)
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("myBookPal")
                        .font(Font.custom("CrimsonText-SemiBold", size: 20))
                        .foregroundStyle(.accent)
                }
            }
            .navigationDestination(item: $addViewBook) { book in
                AddView(showingSheet: $isShowingOnlineSheet, bookItem: $addViewBook, bookAdded: $isBookAdded, bookFailedToAdd: $bookFailedToAdd, book: book, books: books)
            }
            .fullScreenCover(isPresented: $isShowingScanner) {
                NavigationStack {
                    CodeScannerView(codeTypes: [.ean13], showViewfinder: true, isTorchOn: isShowingTorch, completion: handleScan)
                        .overlay {
                            VStack {
                                Text("Place ISBN code inside box.")
                                    .foregroundStyle(.white)
                                    .background {
                                        Rectangle()
                                            .fill(Color.black.opacity(0.5))
                                            .padding(.vertical, -5)
                                            .padding(.horizontal, -5)
                                    }
                                    .accessibilityLabel("Place ISBN code in the middle of the screen")
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.vertical, 125)
                        }
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(action: {
                                    isShowingScanner = false
                                }) {
                                    Text("Cancel")
                                        .foregroundStyle(.white)
                                        .accessibilityLabel("Exit ISBN scanner")
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    isShowingTorch.toggle()
                                }) {
                                    Image(systemName: isShowingTorch ? "bolt.circle" : "bolt.slash.circle")
                                        .foregroundStyle(.white)
                                        .accessibilityLabel("Enable/disable flashlight")
                                }
                            }
                        }
                        .ignoresSafeArea()
                }
            }
            .fullScreenCover(isPresented: $isShowingOnlineSheet) {
                SearchView(isShowingSheet: $isShowingOnlineSheet, bookAdded: $isBookAdded, bookFailedToAdd: $bookFailedToAdd, collectionBooks: books)
            }
            .sheet(isPresented: $showManualFormSheet) {
                ManualFormView(collectionBooks: books)
            }
            .onChange(of: books) {
                if books.isEmpty {
                    recentlyViewedBook = nil
                }
            }
            .onChange(of: isbnManager.books) {
                if !isbnManager.books.isEmpty {
                    guard let firstBook = isbnManager.books.first else { return }

                    addViewBook = firstBook
                    
                    if let unwrapped = addViewBook {
                        print(unwrapped.title)
                        
                        showAddViewSheet.toggle()
                    }
                }
            }
//            .onChange(of: isBookAdded) {
//                if isBookAdded {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        withAnimation(.easeOut(duration: 0.3)) {
//                            isBookAdded = false
//                        }
//                    }
//                }
//            }
//            .onChange(of: bookFailedToAdd) {
//                if bookFailedToAdd {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        withAnimation(.easeOut(duration: 0.3)) {
//                            bookFailedToAdd = false
//                        }
//                    }
//                }
//            }
            .onAppear {
                print("DEBUG: \(books)")
                isEditing = false
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .alert("Delete Book", isPresented: $activateBookDeletionAlert) {
            Button("Yes", role: .destructive, action: {
                deleteBookFromCollection(selectedDeletionBook)
                reset()
            })
            Button("Cancel", role: .cancel, action: reset)
        } message: {
            Text("Are you sure you want to delete this book?")
        }
    }
    
    func deleteBookFromCollection(_ bookToDelete: Book?) {
        print("Called the function and book name is: \(bookToDelete?.title ?? "N/A")")
        let index = books.firstIndex(of: bookToDelete!) ?? nil
        
        if index != nil {
            modelContext.delete(bookToDelete!)
            hapticsManager.playRemovedBookHaptic()
            deletedBookTitle = (bookToDelete?.title.uppercased())!
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        isShowingTorch = false
        
        print("DEBUG: handling scanner result.")
        
        switch result {
        case .success(let result):
            hapticsManager.playFoundISBNHaptic()
            
            let isbnString = result.string
            
            isbnManager.isbnNumber = isbnString
            isbnManager.fetchBookInfo()
        case .failure(let error):
            print("Scanning failed: \(error)")
        }
    }
    
    func reset() {
        activateBookDeletionAlert = false
        selectedDeletionBook = nil
    }
}

//#Preview {
//    ContentView(books)
//}
