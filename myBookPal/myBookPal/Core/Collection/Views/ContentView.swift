//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/14/24.
//

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
                                        VStack(alignment: .leading) {
                                            WebImage(url: URL(string: mostRecent?.coverImage ?? "N/A")) { image in
                                                image
                                                    .ContentViewImageExtension()
                                            } placeholder: {
                                                Rectangle()
                                                    .placeHolderModifier()
                                            }
                                        }
                                        
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
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding(.horizontal, -15)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, -20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    Rectangle()
                        .frame(width: 350, height: 2)
                        .foregroundStyle(.gray.opacity(0.30))
                    
                    if recentlyViewedBook != nil && books.contains(recentlyViewedBook!) {
                        VStack(alignment: .leading) {
                            Text("Recently Viewed")
                                .font(.title.bold())
                                .fontDesign(.serif)
                            VStack(alignment: .leading) {
                                NavigationLink(destination: LogView(book: recentlyViewedBook!)) {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                WebImage(url: URL(string: recentlyViewedBook?.coverImage ?? "N/A")) { image in
                                                    image
                                                        .ContentViewImageExtension()
                                                } placeholder: {
                                                    Rectangle()
                                                        .placeHolderModifier()
                                                }
                                            }
                                            
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
                                            .frame(maxHeight: .infinity, alignment: .top)
                                            .padding(.horizontal, -15)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, -20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Rectangle()
                            .frame(width: 350, height: 2)
                            .foregroundStyle(.gray.opacity(0.30))
                        
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
                        }
                        .padding(.horizontal, 20)
                        
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
                                        
                                        WebImage(url: URL(string: book.coverImage)) { image in
                                            image
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                .frame(width: 90, height: 150)
                                        } placeholder: {
                                            Rectangle()
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
                            NavigationLink(destination: SearchView(collectionBooks: books)) {
                                Text("Search Online")
                            }
                            
//                            Text("Enter Manually")
//                            
//                            Text("Scan ISBN Number")
                            
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
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottomTrailing)
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
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu {
//                        NavigationLink(destination: SearchView(collectionBooks: books)) {
//                            Text("Search Online")
//                        }
//                        
//                        Text("Enter Manually")
//                        
//                        Text("Scan ISBN Number")
//                        
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
            }
            .onChange(of: books) {
                if books.isEmpty {
                    recentlyViewedBook = nil
                }
            }
            .onAppear {
                print("DEBUG: \(books)")
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
            
            deletedBookTitle = bookToDelete.title.uppercased()
            activateDeleteAlert()
        }
    }
    
    func reset() {
        activateBookDeletionAlert = false
    }
}

//#Preview {
//    ContentView(books)
//}
