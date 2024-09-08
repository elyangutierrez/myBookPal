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
    var books: Set<Book>
    @State private var activateSheet = false
    
    let options = ["Ascending", "Descending"]
    @State private var selectedChoice = ""
    
    var searchResults: [Book] {
        if searchText.isEmpty {
            return Array(books)
        } else {
            return books.filter { $0.title.contains(searchText) }
        }
    }
    
    @State private var selectedView = 0
    @State private var showBookInfomation = false
    @State private var isEditing = false
    @State private var selectedBooks = Set<Book>()
    @State private var activateBookDeletionAlert = false
    @State private var deletedBookTitle = ""
    @State private var recentlyViewedBook: Book?
    
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
                                        WebImage(url: URL(string: mostRecent?.coverImage ?? "N/A")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                .frame(width: 180, height: 210)
                                                .shadow(color: .black.opacity(0.30), radius: 5)
                                                .padding(.horizontal, 10)
                                        } placeholder: {
                                            Rectangle()
                                                .aspectRatio(contentMode: .fit)
                                                .shadow(radius: 15)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                .frame(width: 180, height: 210)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            
                                            Text(mostRecent?.title ?? testBook.title)
                                                .frame(maxWidth: 215, alignment: .leading)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .multilineTextAlignment(.leading)
                                                .font(.system(size: 17).bold())
                                                .padding(.vertical, 2)
                                            
                                            
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
                    
                    if recentlyViewedBook != nil {
                        
                        let library = Library(books: Array(books))
                        let mostRecentlyViewedBook = library.getRecentlyViewedBook
                        
                        VStack(alignment: .leading) {
                            Text("Recently Viewed")
                                .font(.title.bold())
                                .fontDesign(.serif)
                            VStack(alignment: .leading) {
                                NavigationLink(destination: LogView(book: recentlyViewedBook!)) {
                                    VStack {
                                        HStack {
                                            WebImage(url: URL(string: recentlyViewedBook?.coverImage ?? "N/A")) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                    .frame(width: 180, height: 210)
                                                    .shadow(color: .black.opacity(0.30), radius: 5)
                                                    .padding(.horizontal, 10)
                                            } placeholder: {
                                                Rectangle()
                                                    .aspectRatio(contentMode: .fit)
                                                    .shadow(radius: 15)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                    .frame(width: 180, height: 210)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                
                                                Text(recentlyViewedBook?.title ?? testBook.title)
                                                    .frame(maxWidth: 215, alignment: .leading)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .multilineTextAlignment(.leading)
                                                    .font(.system(size: 17).bold())
                                                    .padding(.vertical, 2)
                                                
                                                
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
                            .font(.title2.bold())
                            .fontDesign(.serif)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                    }
                    
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top) {
                            ForEach(searchResults, id: \.self) { book in
                                NavigationLink(destination: LogView(book: book)) {
                                    VStack {
                                        WebImage(url: URL(string: book.coverImage)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                .frame(width: 100, height: 150)
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
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .scrollContentBackground(.hidden)
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("myBookPal")
                        .font(Font.custom("CrimsonText-SemiBold", size: 20))
                }
            }
        }
        .alert("Book Deleted", isPresented: $activateBookDeletionAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("\(deletedBookTitle) was removed from your collection.")
        }
    }
    
    private func toggleSelected(of book: Book) {
        if selectedBooks.contains(book) {
            selectedBooks.remove(book)
        } else {
            selectedBooks.insert(book)
        }
    }
    
    private mutating func deletedSelectedBooks() {
        for book in selectedBooks {
            if let index = books.firstIndex(of: book) {
                modelContext.delete(books[index])
                books.remove(at: index)
            }
        }
    }
    
    func saveRecentlyViewedBook(_ book: RecentlyViewedBook) {
        if let encodedBook = try? JSONEncoder().encode(book) {
            UserDefaults.standard.setValue(encodedBook, forKey: "recentlyViewedBook")
        }
    }
    
    func loadRecentlyViewedBook() -> RecentlyViewedBook? {
        if let savedBookData = UserDefaults.standard.data(forKey: "recentlyViewedBook") {
            if let savedBook = try? JSONDecoder().decode(RecentlyViewedBook.self, from: savedBookData) {
                return savedBook
            }
        }
        return nil
    }

}

//#Preview {
//    ContentView(books)
//}
