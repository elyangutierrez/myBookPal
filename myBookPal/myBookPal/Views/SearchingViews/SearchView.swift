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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: AddView(book: book)) {
                        HStack {
                            AsyncImage(url: URL(string: book.imageLinks?.secureThumbnailURL ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 90)
                                case .failure(let error):
                                    let _ = print("Image error", error)
                                    Color.red
                                case .empty:
                                    EmptyBookCoverView(book: book)
                                @unknown default:
                                    fatalError()
                                }
                            }
                            .frame(width: 50, height: 70)
                            Spacer()
                                .frame(width: 50)
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .fontWeight(.bold)
                                Text(book.getAuthor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Find Book")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Enter Book Title")
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    books.removeAll()
                }
            }
            .onSubmit(of: .search) {
                fetchBookInfo()
            }
            
        }
    }
    
    func fetchBookInfo() {
        let lowercasedText = searchText.lowercased()
        guard let encodedQuery = lowercasedText.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)") else {
            return
        }
        print("---------------------------------")
        print("The url has been recieved!")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("---------------------------------")
            if let data = data {
                print("Recieved the data..")
                let someData = String(data: data, encoding: .utf8)
                print(someData ?? "None")
                do {
                    let response = try JSONDecoder().decode(BookResponse.self, from: data)
                    print("The response was recieved.")
                    
                    DispatchQueue.main.async {
                        self.books = response.items.compactMap { $0.volumeInfo }
                    }
                } catch {
                    print("The do block failed: \(error.localizedDescription)")
                }
            } else {
                print("The data couldn't be recieved")
            }
        }.resume()
    }
    
}

#Preview {
    SearchView()
}
