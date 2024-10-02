//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/14/24.
//

import CodeScanner
import SDWebImageSwiftUI
import SlidingTabView
import SwiftData
import SwiftUI

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
            ScrollView {
                if !networkMonitor.isConnected {
                    Spacer()
                        .frame(height: 220)
                    
                    ContentUnavailableView("No WiFi Connection", systemImage: "wifi.slash", description: Text("Please check your WiFi connection."))
                    
                    
                    
                } else if books.isEmpty {
                    Spacer()
                        .frame(height: 220)
                    
                    ContentUnavailableView("No Books Avaliable",
                                           systemImage: "books.vertical",
                                           description: Text("Add one to get started!"))
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
                                                        .frame(width: 140, height: 210)
                                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                        .shadow(color: .black.opacity(0.30), radius: 5)
                                                }
                                            } else {
                                                let image = imageString.toImage()
                                                
                                                image?
                                                    .resizable()
                                                    .frame(width: 140, height: 210)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                    .shadow(color: .black.opacity(0.30), radius: 5)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
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
                                                    .offset(y: 10)
                                                
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
                                        .padding(.horizontal, -30)
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
                                                            .frame(width: 140, height: 210)
                                                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                            .shadow(color: .black.opacity(0.30), radius: 5)
                                                    }
                                                } else {
                                                    let image = imageString.toImage()
                                                    
                                                    image?
                                                        .resizable()
                                                        .frame(width: 140, height: 210)
                                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                        .shadow(color: .black.opacity(0.30), radius: 5)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
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
                                                        .offset(y: 10)
                                                    
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
                                            .padding(.horizontal, -30)
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
                        
                        Button(action: {
                            withAnimation(.spring(duration: 0.2, bounce: 0.1)) {
                                isEditing.toggle()
                            }
                        }) {
                            Text("Edit")
                                .fontDesign(.serif)
                                .fontWeight(.semibold)
                            Image(systemName: "pencil")
                                .accessibilityLabel("Editing pencil to edit collection")
                        }
                        .padding(.horizontal, 20)
                        .accessibilityAddTraits(.isButton)
                        
                    }
                    
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top) {
                            ForEach(searchResults, id: \.self) { book in
                                NavigationLink(destination: LogView(book: book)) {
                                    VStack {
                                        if isEditing {
                                            Circle()
                                                .fill(.gray.opacity(0.2))
                                                .frame(width: 30)
                                                .overlay {
                                                    Button(action: {
                                                        deleteBookFromCollection(book)
                                                    }) {
                                                        Image(systemName: "trash")
                                                            .foregroundStyle(.red)
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
                                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                    .shadow(color: .black.opacity(0.30), radius: 5)
                                            }
                                        } else {
                                            let image = imageString.toImage()
                                            
                                            image?
                                                .resizable()
                                                .frame(width: 90, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
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
                            .accessibilityLabel("Collection of books")
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                }
            }
            .overlay {
                VStack {
                    VStack {
                        Menu {
//                            NavigationLink(destination: SearchView(collectionBooks: books)) {
//                                Text("Search Online")
//                            }
                            
                            Button(action: {
                                isShowingOnlineSheet.toggle()
                            }) {
                                Text("Search Online")
                                    .accessibilityHint("Search the book online", isEnabled: showBookAddingVO)
                            }
                            
                            Button(action: {
                                isShowingScanner.toggle()
                            }) {
                                Text("Scan ISBN Number")
                                    .accessibilityHint("Scan the ISBN number", isEnabled: showBookAddingVO)
                            }
                            
                            Button(action: {
                                showManualFormSheet.toggle()
                            }) {
                                Text("Manually Add Book")
                                    .accessibilityHint("Manually add the book", isEnabled: showBookAddingVO)
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
                                .accessibilityHint("Show a menu regarding book adding")
                            
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottomTrailing)
                    .onTapGesture {
                        showBookAddingVO.toggle()
                    }
                    .accessibilityAddTraits(.isButton)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 10)
                .padding(.vertical, -20)
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
                AddView(showingSheet: $isShowingOnlineSheet, bookItem: $addViewBook, book: book, books: books)
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
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    isShowingTorch.toggle()
                                }) {
                                    Image(systemName: isShowingTorch ? "bolt.circle" : "bolt.slash.circle")
                                        .foregroundStyle(.white)
                                }
                            }
                         }
                        .ignoresSafeArea()
                }
            }
            .fullScreenCover(isPresented: $isShowingOnlineSheet) {
                SearchView(isShowingSheet: $isShowingOnlineSheet, collectionBooks: books)
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
//                    print("DEBUG: \(firstBook.title)")
                    
                    addViewBook = firstBook
                    
                    if let unwrapped = addViewBook {
                        print(unwrapped.title)
                        
                        showAddViewSheet.toggle()
                    }
                }
            }
            .onAppear {
                print("DEBUG: \(books)")
                isEditing = false
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .alert("Book Deleted", isPresented: $activateBookDeletionAlert) {
            Button("Ok", role: .cancel, action: reset)
        } message: {
            Text("\(deletedBookTitle) has been removed.")
        }
    }
    
    func activateDeleteAlert() {
        activateBookDeletionAlert = true
    }
    
    func deleteBookFromCollection(_ bookToDelete: Book) {
        print("Called the function and book name is: \(bookToDelete.title)")
        let index = books.firstIndex(of: bookToDelete) ?? nil
        
        if index != nil {
            modelContext.delete(bookToDelete)
            hapticsManager.playRemovedBookHaptic()
            deletedBookTitle = bookToDelete.title.uppercased()
            activateDeleteAlert()
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
    }
}

//#Preview {
//    ContentView(books)
//}
