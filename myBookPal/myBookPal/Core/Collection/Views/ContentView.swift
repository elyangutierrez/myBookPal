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
import SwipeActions
import SwiftData
import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(NetworkMonitor.self) private var networkMonitor
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
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
    @State private var isbnManager = FetchISBNBookInfoViewModel()
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
    @State private var showCollectionInfo = false
    @State private var bookDeleted = false
    @State private var scanningFailed = false
    
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
                List {
                    if !books.isEmpty {
                        let library = Library(books: Array(books))
                        let mostRecent = library.getMostRecentBook
                        
                        VStack {
                            Text("Recently Added")
                                .font(.title2.bold())
                                .fontDesign(.serif)
                        }
                        .listRowSeparator(.hidden, edges: .all)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                let imageString = mostRecent?.coverImage ?? "N/A"
                                
                                let _ = print(imageString)
                                
                                if imageString.contains("https") {
                                    
                                    WebImage(url: URL(string: imageString)) { image in
                                        image
                                            .image?.resizable()
                                            .frame(width: 60, height: 110)
                                            .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 2.0)
                                                    .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                    .fill(.clear)
                                                    .frame(width: 60, height: 110)
                                            }
                                    }
                                    .onSuccess { image, data, cacheType in
                                        if let someDataTwo = image.pngData() {
                                            mostRecent?.sharedImageData = someDataTwo
                                        }
                                        
                                    }
                                } else if imageString == "N/A" {
                                    RoundedRectangle(cornerRadius: 2.0)
                                        .fill(.starGrey)
                                        .frame(width: 60, height: 110)
                                        .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 2.0)
                                                .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                .fill(.clear)
                                                .frame(width: 60, height: 110)
                                                .overlay {
                                                    VStack {
                                                        Text("N/A")
                                                            .foregroundStyle(.gray)
                                                    }
                                                }
                                        }
                                } else if imageString == "" {
                                    RoundedRectangle(cornerRadius: 2.0)
                                        .fill(.starGrey)
                                        .frame(width: 60, height: 110)
                                        .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 2.0)
                                                .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                .fill(.clear)
                                                .frame(width: 60, height: 110)
                                                .overlay {
                                                    VStack {
                                                        Text("N/A")
                                                            .foregroundStyle(.gray)
                                                    }
                                                }
                                        }
                                } else {
                                    let image = imageString.toImage()
                                    
                                    image?
                                        .resizable()
                                        .frame(width: 60, height: 110)
                                        .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 2.0)
                                                .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                .fill(.clear)
                                                .frame(width: 60, height: 110)
                                        }
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(mostRecent?.title ?? "N/A")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    
                                    Text(mostRecent?.author ?? "N/A")
                                        .font(.caption)
                                        .lineLimit(1)
                                    
                                    Text("\(mostRecent?.pages ?? "N/A") pages")
                                        .font(.caption)
                                    
                                    VStack(alignment: .leading) {
                                        StarRatingView(rating: mostRecent?.starRatingSystem?.rating ?? 0.0)
                                            .font(.subheadline)
                                    }
                                    .offset(y: 3)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(mostRecent?.getLogCount ?? 0 > 0 ? "\(mostRecent?.getLogCount ?? 0)" : "0")")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .background {
                                                RoundedRectangle(cornerRadius: 5.0)
                                                    .fill(.complement.opacity(0.70))
                                                    .padding(.horizontal, -5)
                                                    .padding(.vertical, -3)
                                            }
                                    }
                                    .offset(x: 3, y: 28)
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                                .padding(.vertical, -3)
                            }
                            .frame(height: 110)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .swipeActions(edge: .leading) {
                            
                            if let dataToBeShared = mostRecent?.sharedImageData, let uiImage = UIImage(data: dataToBeShared) {
                                let swiftImage = Image(uiImage: uiImage)
                                ShareLink(item: swiftImage, message: Text("I'm currently reading this book. You should check it out!"), preview: SharePreview(mostRecent?.title ?? "N/A", image: swiftImage), label: {
                                    Label("", systemImage: "square.and.arrow.up")
                                    
                                })
                                .tint(.gray)
                            }
                        
                            Button(action: {
                                
                            }) {
                                let formatted = String(format: "%.1f", (mostRecent?.completionStatus ?? 0) * 100)
                                Label("\(formatted == "0.0" ? "0" : formatted)%", systemImage: mostRecent?.completionStatus ?? 0 == 1 ? "checkmark.circle" : "progress.indicator")
                            }
                            .tint(mostRecent?.completionStatus ?? 0 == 1 ? Color.green : Color.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(action: {
                                guard let recent = mostRecent else { return }
                                selectedDeletionBook = recent
                                activateBookDeletionAlert.toggle()
                            }) {
                                Label("", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            NavigationLink(destination: LogView(book: mostRecent!)) {
                                Label("", systemImage: "list.dash.header.rectangle")
                            }
                            .tint(.complement)
                        }
                        .background {
                            NavigationLink("", destination: LogView(book: mostRecent!))
                                .opacity(0)
                        }
                        
                        VStack {
                            HStack {
                                Text("Collection")
                                    .font(.title2.bold())
                                    .fontDesign(.serif)
                                
                                Spacer()
                                    .frame(width: 20)
                                
                                Text("\(books.count)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .fill(.complement)
                                            .padding(.horizontal, -5)
                                            .padding(.vertical, -3)
                                    }
                                    .offset(x: -7)
                            }
                        }
                        .listRowSeparator(.hidden, edges: .all)
                         
                        ForEach(searchResults) { book in
                            VStack(alignment: .leading) {
                                HStack {
                                    let imageString = book.coverImage
                                    
                                    let _ = print(imageString)
                                    
                                    if imageString.contains("https") {
                                        WebImage(url: URL(string: imageString)) { image in
                                            image
                                                .image?.resizable()
                                                .frame(width: 60, height: 110)
                                                .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 2.0)
                                                        .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                        .fill(.clear)
                                                        .frame(width: 60, height: 110)
                                                }
                                        }
                                        .onSuccess { image, data, cacheType in
                                            if let someDataTwo = image.pngData() {
                                                book.sharedImageData = someDataTwo
                                            }
                                            
                                        }
                                    } else if imageString == "N/A" {
                                        RoundedRectangle(cornerRadius: 2.0)
                                            .fill(.starGrey)
                                            .frame(width: 60, height: 110)
                                            .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 2.0)
                                                    .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                    .fill(.clear)
                                                    .frame(width: 60, height: 110)
                                                    .overlay {
                                                        VStack {
                                                            Text("N/A")
                                                                .foregroundStyle(.gray)
                                                        }
                                                    }
                                            }
                                    } else if imageString == "" {
                                        RoundedRectangle(cornerRadius: 2.0)
                                            .fill(.starGrey)
                                            .frame(width: 60, height: 110)
                                            .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 2.0)
                                                    .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                    .fill(.clear)
                                                    .frame(width: 60, height: 110)
                                                    .overlay {
                                                        VStack {
                                                            Text("N/A")
                                                                .foregroundStyle(.gray)
                                                        }
                                                    }
                                            }
                                    } else {
                                        let image = imageString.toImage()
                                        
                                        image?
                                            .resizable()
                                            .frame(width: 60, height: 110)
                                            .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 2.0)
                                                    .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                    .fill(.clear)
                                                    .frame(width: 60, height: 110)
                                            }
                                    }
                                    
                                    VStack(alignment: .leading) {

                                        Text(book.title)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                        
                                        Text(book.author)
                                            .font(.caption)
                                            .lineLimit(1)
                                        
                                        Text("\(book.pages) pages")
                                            .font(.caption)
                                        
                                        VStack(alignment: .leading) {
                                            StarRatingView(rating: book.starRatingSystem?.rating ?? 0.0)
                                                .font(.subheadline)
                                        }
                                        .offset(y: 3)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(book.getLogCount ?? 0 > 0 ? "\(book.getLogCount ?? 0)" : "0")")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.white)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 5.0)
                                                        .fill(.complement.opacity(0.70))
                                                        .padding(.horizontal, -5)
                                                        .padding(.vertical, -3)
                                                }
                                        }
                                        .offset(x: 3, y: 28)
                                    }
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .padding(.vertical, -3)
                                }
                                .frame(height: 110)
                            }
                            .swipeActions(edge: .leading) {
                                
                                if let dataToBeShared = book.sharedImageData, let uiImage = UIImage(data: dataToBeShared) {
                                    let swiftImage = Image(uiImage: uiImage)
                                    ShareLink(item: swiftImage, message: Text("I'm currently reading this book. You should check it out!"), preview: SharePreview(book.title, image: swiftImage), label: {
                                        Label("", systemImage: "square.and.arrow.up")
                                        
                                    })
                                    .tint(.gray)
                                }
                                
                                Button(action: {
                                    
                                }) {
                                    let formatted = String(format: "%.0f", (book.completionStatus) * 100)
                                    Label("\(formatted == "0.0" ? "0" : formatted)%", systemImage: book.completionStatus == 1 ? "checkmark.circle" : "progress.indicator")
                                }
                                .tint(book.completionStatus == 1 ? Color.green : Color.blue)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    selectedDeletionBook = book
                                    activateBookDeletionAlert.toggle()
                                }) {
                                    Label("", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                NavigationLink(destination: LogView(book: book)) {
                                    Label("", systemImage: "list.dash.header.rectangle")
                                }
                                .tint(.complement)
                            }
                            .background {
                                NavigationLink("", destination: LogView(book: book))
                                    .opacity(0)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.grouped)
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if books.isEmpty {
                    VStack {
                        ContentUnavailableView {
                            Label("No Books Found", systemImage: "books.vertical.fill")
                                .tint(.black)
                        } description: {
                            Text("Click the '+' to get started!")
                        }
                    }
                }
                
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
                                                .frame(width: 50, height: 80)
                                                .overlay {
                                                    Rectangle()
                                                        .stroke(.gray.opacity(0.30), lineWidth: 1)
                                                        .fill(.clear)
                                                        .frame(width: 50, height: 80)
                                                }
                                        }
                                    } else {
                                        let image = imageString.toImage()
                                        
                                        image?
                                            .resizable()
                                            .frame(width: 50, height: 80)
                                            .overlay {
                                                Rectangle()
                                                    .stroke(.gray.opacity(0.30), lineWidth: 1)
                                                    .fill(.clear)
                                                    .frame(width: 50, height: 80)
                                            }
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
                }
                
                if bookFailedToAdd {
                    VStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(.gray.opacity(0.30), lineWidth: 1)
                            .fill(.regularMaterial)
                            .frame(width: 175, height: 100)
                            .shadow(radius: 5)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        bookFailedToAdd = false
                                    }
                                }
                            }
                            .overlay {
                                VStack {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Failed To Add Book")
//                                        .font(.footnote)
                                }
                            }
                    }
                }
                
                if scanningFailed {
                    VStack {
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(.gray.opacity(0.30), lineWidth: 1)
                            .fill(.regularMaterial)
                            .frame(width: 175, height: 100)
                            .shadow(radius: 5)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        scanningFailed = false
                                        isbnManager.noFailedOccured = true
                                    }
                                }
                            }
                            .overlay {
                                VStack {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Failed To Add Book")
//                                        .font(.footnote)
                                }
                            }
                    }
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
                .padding(.vertical, 10)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("myBookPal")
                        .font(Font.custom("CrimsonText-SemiBold", size: 20))
                        .foregroundStyle(.accent)
                }
            }
            .navigationDestination(item: $addViewBook) { book in
                AddView(showingSheet: $showAddViewSheet, bookItem: $addViewBook, bookAdded: $isBookAdded, bookFailedToAdd: $bookFailedToAdd, book: book, books: books)
            }
            .fullScreenCover(isPresented: $isShowingScanner) {
                NavigationStack {
                    CodeScannerView(codeTypes: [.ean13], showViewfinder: true, isTorchOn: isShowingTorch, completion: handleScan)
                        .overlay {
                            VStack {
                                Text("Scanner only supports ISBN-13.")
                                    .foregroundStyle(.white)
                                    .background {
                                        Rectangle()
                                            .fill(Color.black.opacity(0.5))
                                            .padding(.vertical, -5)
                                            .padding(.horizontal, -5)
                                    }
                                    .accessibilityLabel("Scanner only supports ISBN-13.")
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
            .searchable(text: $searchText)
            .onChange(of: books) {
                if books.isEmpty {
                    recentlyViewedBook = nil
                }
            }
            .onChange(of: isbnManager.foundBook) {
                if !isbnManager.books.isEmpty {
                    guard let firstBook = isbnManager.books.first else { return }

                    addViewBook = firstBook
                    
                    if let unwrapped = addViewBook {
                        print(unwrapped.title)
                        
                        showAddViewSheet.toggle()
                        print("Value of showAddViewSheet: \(showAddViewSheet)")
                        isbnManager.foundBook = false
                    }
                }
            }
            .onChange(of: isbnManager.noFailedOccured) {
                if !isbnManager.noFailedOccured {
                    scanningFailed.toggle()
                }
            }
//            .onAppear {
//                print("DEBUG: \(books)")
//                isEditing = false
//            }
        }
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
            print(isbnString)
            
            isbnManager.isbnNumber = isbnString
            print("Value of isbnNumber: \(isbnManager.isbnNumber)")
            isbnManager.fetchBookInfo()
        case .failure(let error):
            print("Scanning failed: \(error)")
            
            scanningFailed.toggle()
            
            // Show a overlay if scanning failed..
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
