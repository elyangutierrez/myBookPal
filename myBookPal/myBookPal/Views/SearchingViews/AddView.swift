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
                ZStack {
//                    Color.red
//                        .frame(width: 450, height: 475)
                    BackgroundBookCoverView(bookImage: book.imageLinks?.secureThumbnailURL ?? "")
                        .opacity(0.7)
                        .brightness(-0.4)
                        .padding(.vertical, -270)
                }
                .ignoresSafeArea()
                
                VStack {
                    Rectangle()
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
                    
                    Text(book.getAuthor)
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 25)
                    
                    HStack {
                        Image(.openBook2)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(book.getPageCount)
                            .font(.system(size: 17))
                    }
                    .padding(.vertical, -10)
                    
                    Button(action: {
                        //
                    }) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(.gray)
                            .frame(width: 200, height: 50)
                            .padding(.vertical, 25)
                            .overlay {
                                Text("Add To Collection")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                    }
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
