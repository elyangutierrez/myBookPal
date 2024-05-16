//
//  AddView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    var book: VolumeInfo

    @State private var showAlert = false
    
    let authorText = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: 50)
                    if book.imageLinks?.secureThumbnailURL == "" {
                        EmptyBookCoverView(book: book)
                            .shadow(radius: 10)
                    } else {
                        BookCoverView(bookImage: book.imageLinks?.secureThumbnailURL ?? "")
                            .frame(width: 250, height: 310)
                            .shadow(radius: 10)
                    }
                    Text(book.title)
                        .font(.title2.bold())
                        .padding()
                    Text(book.getAuthor)
                        .font(.custom("Author", fixedSize: 19))
                        .foregroundStyle(authorText)
                        .padding(-12)
                    HStack {
                        if book.getPageCount == "0" {
                            Text("N/A")
                                .font(.headline)
                            Image("open-book-2")
                                .resizable()
                                .frame(width: 30, height: 30)
                        } else {
                            Text(book.getPageCount)
                                .font(.headline)
                            Image("open-book-2")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        addBookToCollection()
                    }) {
                        Capsule()
                            .fill(.gray.opacity(0.30))
                            .frame(width: 200, height: 35)
                            .overlay {
                                Capsule()
                                    .stroke(authorText.opacity(0.35), lineWidth: 1)
                                Text("Add To Collection")
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                            }
                        
                    }
                    .offset(x: 2)
                    .padding(-8)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("Book Added", isPresented: $showAlert) {
            Button("Ok") { }
        } message: {
            Text("\(book.title) has been added to your collection.")
        }
    }
    
    func addBookToCollection() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, pages: book.getPageCount)
        modelContext.insert(newBook)
        showAlert = true
    }
}

#Preview {
    let example = VolumeInfo(title: "Dune", authors: ["Frank Herbert"], pageCount: 345, categories: ["Fiction"])
    
    return AddView(book: example)
}
