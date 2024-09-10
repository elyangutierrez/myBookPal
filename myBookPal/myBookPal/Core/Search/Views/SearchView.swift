//
//  SearchView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State var books: [VolumeInfo] = []
    @State private var currentBook: VolumeInfo?
    var collectionBooks: [Book]
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 165), spacing: -15)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .frame(height: 30)
                LazyVGrid(columns: adaptiveColumn, spacing: 10) {
                    ForEach(books, id: \.self) { book in
                        Rectangle()
                            .fill(.white)
                            .frame(width: 165, height: 350)
                            .overlay {
                                VStack {
                                    AsyncImage(url: URL(string: book.imageLinks?.secureThumbnailURL ?? "")) { phase in
                                        switch phase {
                                        case .empty:
                                            VStack {
                                                ProgressView()
                                                
                                                Spacer()
                                                    .frame(height: 70)
                                            }
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 165, height: 245)
                                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                .offset(y: -50)
                                        case .failure(let error):
                                            Color.red
                                            let _ = print(error)
                                        @unknown default:
                                            fatalError()
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Spacer()
                                        .frame(height: 210)
                                    Text(book.title)
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                    
                                    Spacer()
                                        .frame(height: 5)
                                    
                                    Text(book.getAuthor)
//                                        .offset(y: -3)
                                        .lineLimit(1)
                                        .font(.system(size: 13))
//                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
                            }
                            .onTapGesture {
                                currentBook = book
                                print("Tapped")
                                print("Value of book: \(currentBook?.title ?? "N/A")")
                            }
                    }
                }
//                .padding(.horizontal, 10)
            }
            .navigationTitle("Find Book")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $currentBook) { book in
                let _ = print("Going to destination.")
                AddView(book: book, books: collectionBooks)
            }
            .searchable(text: $searchText, prompt: "Enter Book Title")
            
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    books.removeAll()
                }
            }
            .onSubmit(of: .search) {
                fetchBookInfo()
            }
            .overlay {
                if searchText.isEmpty {
                    ContentUnavailableView {
                        Label("No Result Found", systemImage: "magnifyingglass")
                    } description: {
                        Text("Enter a book title to begin searching!")
                    }
                }
            }
        }
    }
    
    func fetchBookInfo() {
        let lowercasedText = searchText.lowercased()
        guard let encodedQuery = lowercasedText.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)") else {
            return
        } // the encodedQuery is what the user has searched for in which is then plugged into the url
        print("---------------------------------")
        print("The url has been recieved!")
        
        URLSession.shared.dataTask(with: url) { data, response, error in // fetchs the data within the url and uses a closure to store the data, response, and error parameters
            print("---------------------------------")
            if let data = data {
                print("Recieved the data..")
                let someData = String(data: data, encoding: .utf8)
                print(someData ?? "None")
                do {
                    let response = try JSONDecoder().decode(BookResponse.self, from: data) // decodes the response into the BookAPIType structs from the data
                    print("The response was recieved.")
                    
                    DispatchQueue.main.async { // allows this process to be done in the background without causing lag
                        self.books = response.items.compactMap { $0.volumeInfo } // sets book to the infomation inside of the current volumeInfo object
                    }
                } catch {
                    print("The do block failed: \(error.localizedDescription)")
                }
            } else {
                print("The data couldn't be recieved")
            }
        }.resume() // is what runs the URLSession
    }
    
}

#Preview {
    SearchView(collectionBooks: [Book]())
}
