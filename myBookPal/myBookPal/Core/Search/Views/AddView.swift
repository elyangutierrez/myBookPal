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
    var books: [Book]

    @State private var showAlert = false
    
    let authorText = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    @State private var enterPageCountBool = false
    @State private var manualBookCount = ""
    @State private var enterGenreBool = false
    @State private var enterGenre = ""
    @State private var enterBothBool = false
    
    @Environment(\.requestReview) var requestReview
    @AppStorage("bookCompletionCount") var bookCompletionCount = 0
    
    @State private var bookIsInCollection = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    BackgroundBookCoverView(bookImage: book.imageLinks?.secureThumbnailURL ?? "")
                        .blur(radius: 5.0, opaque: true)
                        .padding(.vertical, -270)
                }
                .ignoresSafeArea()
                
                VStack {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 200, height: 255)
                        .padding(.vertical, 60)
                        .overlay {
                            BookCoverView(bookImage: book.imageLinks?.secureThumbnailURL ?? "")
                        }
                }
                
                VStack {
                    Text(book.title)
                        .font(.system(size: 21).bold())
                        .frame(width: 250, alignment: .center)
                        .padding(.vertical, -10)
                    
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
                            Image(systemName: "book.pages")
                                .resizable()
                                .frame(width: 20, height: 25)
                        } else {
                            Text(book.getPageCount)
                                .font(.subheadline)
                            Image(systemName: "book.pages")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding()
                    
                    if book.getPageCount == "0" && book.getCatagory == "N/A" {
                        Button(action: {
                            enterBothBool.toggle()
                        }) {
                            Capsule()
                                .fill(.buttonGray)
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
                    } else if book.getPageCount == "0" {
                        Button(action: {
                            enterPageCountBool.toggle()
                        }) {
                            Capsule()
                                .fill(.buttonGray)
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
                    } else if book.getCatagory == "N/A" {
                        Button(action: {
                            enterGenreBool.toggle()
                        }) {
                            Capsule()
                                .fill(.buttonGray)
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
                    }
                    
                    Button(action: {
                        addBookToCollection()
                    }) {
                        Capsule()
                            .fill(.buttonGray)
                            .frame(width: 200, height: 35)
                            .overlay {
                                Capsule()
                                    .stroke(authorText.opacity(0.35), lineWidth: 1)
                                Text("Add To Collection")
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                            }
                        
                    }
                    .padding()
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
        
        .alert("Already in Collection", isPresented: $bookIsInCollection) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("This book is already in the collection.")
        }
        
    }
    
    func addBookToCollection() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: book.getCatagory, pages: book.getPageCount)
        
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else {
            modelContext.insert(newBook)
            bookCompletionCount += 1
            showAlert = true
        }
    }
    
    func secondaryBookInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: book.getCatagory, pages: manualBookCount)
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else {
            modelContext.insert(newBook)
            bookCompletionCount += 1
            showAlert = true
        }
    }
    
    func genreBookInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: enterGenre, pages: book.getPageCount)
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else {
            modelContext.insert(newBook)
            bookCompletionCount += 1
            showAlert = true
        }
    }
    
    func twoEmptyFieldsInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: enterGenre, pages: manualBookCount)
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else {
            modelContext.insert(newBook)
            bookCompletionCount += 1
            showAlert = true
        }
    }
    
    @MainActor func showReview() {
        
        print(bookCompletionCount)
        
        if bookCompletionCount == 5 {
            requestReview()
        }
    }
}

#Preview {
    let example = VolumeInfo(title: "Dune", authors: ["Frank Herbert"], pageCount: 0, categories: ["N/A"])
    
    return AddView(book: example, books: [Book]())
}
