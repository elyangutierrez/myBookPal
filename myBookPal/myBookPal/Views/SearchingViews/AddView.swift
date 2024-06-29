//
//  AddView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import StoreKit
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    var book: VolumeInfo

    @State private var showAlert = false
    
    let authorText = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    @State private var enterPageCountBool = false
    @State private var manualBookCount = ""
    @State private var enterGenreBool = false
    @State private var enterGenre = ""
    @State private var enterBothBool = false
    
    @Environment(\.requestReview) var requestReview
    @AppStorage("bookCompletionCount") var bookCompletionCount = 0
    
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
//                    Text(book.getAuthor)
//                        .font(.custom("Author", fixedSize: 19))
//                        .foregroundStyle(authorText)
//                        .padding(-12)
                    HStack {
                        Text(book.getAuthor)
                            .font(.subheadline)
                        
                        RectangleLineView()
                        
                        Text(book.getCatagory)
                            .font(.subheadline)
                        
                        RectangleLineView()
                        
                        if book.getPageCount == "0" {
                            Text("N/A")
                                .font(.subheadline)
                            Image("open-book-2")
                                .resizable()
                                .frame(width: 30, height: 30)
                        } else {
                            Text(book.getPageCount)
                                .font(.subheadline)
                            Image("open-book-2")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding(.bottom, 25)
                    
                    if book.getPageCount == "0" && book.getCatagory == "N/A" {
                        Button(action: {
                            enterBothBool.toggle()
                        }) {
                            Capsule()
                                .fill(.gray.opacity(0.30))
                                .frame(width: 230, height: 35)
                                .overlay {
                                    Capsule()
                                        .stroke(authorText.opacity(0.35), lineWidth: 1)
                                    Text("Manually Page And Genre")
                                        .foregroundStyle(.black)
                                        .fontWeight(.semibold)
                                }
                        }
                        .padding()
                        .offset(y: -10)
                    } else if book.getPageCount == "0" {
                        Button(action: {
                            enterPageCountBool.toggle()
                        }) {
                            Capsule()
                                .fill(.gray.opacity(0.30))
                                .frame(width: 230, height: 35)
                                .overlay {
                                    Capsule()
                                        .stroke(authorText.opacity(0.35), lineWidth: 1)
                                    Text("Manually Enter Page Count")
                                        .foregroundStyle(.black)
                                        .fontWeight(.semibold)
                                }
                        }
                        .padding()
                        .offset(y: -10)
                    } else if book.getCatagory == "N/A" {
                        Button(action: {
                            enterGenreBool.toggle()
                        }) {
                            Capsule()
                                .fill(.gray.opacity(0.30))
                                .frame(width: 230, height: 35)
                                .overlay {
                                    Capsule()
                                        .stroke(authorText.opacity(0.35), lineWidth: 1)
                                    Text("Manually Enter Genre")
                                        .foregroundStyle(.black)
                                        .fontWeight(.semibold)
                                }
                        }
                        .padding()
                        .offset(y: -10)
                    }
                    
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
            .preferredColorScheme(.light)
        }
        .alert("Book Added", isPresented: $showAlert) {
            Button("Ok", action: showReview)
        } message: {
            Text("\(book.title) has been added to your collection.")
        }
        
        .alert("Enter Pages and Genre", isPresented: $enterBothBool) {
            Button("Submit", action: twoEmptyFieldsInsertion)
            Button("Cancel", role: .cancel) { }
            TextField("Enter Pages", text: $manualBookCount)
            TextField("Enter Genre", text: $enterGenre)
        } message: {
            Text("Please enter the total pages and genre of \(book.title).")
        }
        
        .alert("Enter Page Count", isPresented: $enterPageCountBool) {
            Button("Submit", action: secondaryBookInsertion)
            Button("Cancel", role: .cancel) { }
            TextField("Enter Total Page Count", text: $manualBookCount)
        } message: {
            Text("Please enter the total amount of pages in \(book.title).")
        }
        
        .alert("Enter Genre", isPresented: $enterGenreBool) {
            Button("Submit", action: genreBookInsertion)
            Button("Cancel", role: .cancel) { }
            TextField("Enter Genre", text: $enterGenre)
        } message: {
            Text("Please enter the genre of \(book.title).")
        }
        
    }
    
    func addBookToCollection() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: book.getCatagory, pages: book.getPageCount)
        modelContext.insert(newBook)
        
        bookCompletionCount += 1
        
        showAlert = true
    }
    
    func secondaryBookInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: book.getCatagory, pages: manualBookCount)
        modelContext.insert(newBook)
        
        bookCompletionCount += 1
        
        showAlert = true
    }
    
    func genreBookInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: enterGenre, pages: book.getPageCount)
        modelContext.insert(newBook)
        
        bookCompletionCount += 1
        
        showAlert = true
    }
    
    func twoEmptyFieldsInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: enterGenre, pages: manualBookCount)
        modelContext.insert(newBook)
        
        bookCompletionCount += 1
        
        showAlert = true
    }
    
    @MainActor func showReview() {
        
        print(bookCompletionCount)
        
        if bookCompletionCount == 5 {
            requestReview()
        }
    }
}

#Preview {
    let example = VolumeInfo(title: "Dune", authors: ["Frank Herbert"], pageCount: 345, categories: ["N/A"])
    
    return AddView(book: example)
}
