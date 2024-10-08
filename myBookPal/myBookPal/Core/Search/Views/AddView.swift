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
    
    @State private var showAlert = false
    @State private var enterPageCountBool = false
    @State private var manualBookCount = ""
    @State private var enterGenreBool = false
    @State private var enterGenre = ""
    @State private var enterBothBool = false
    @State private var bookAddedCounter = 0
    @State private var bookIsInCollection = false
    @State private var hapticsManager = HapticsManager()
    @State private var invalidInfoAlert: Bool = false
    
    @Binding var showingSheet: Bool
    @Binding var bookItem: VolumeInfo?
    
    var book: VolumeInfo
    var books: [Book]

    let authorText = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(showsIndicators: true) {
                    ZStack {
                        BackgroundBookCoverView(bookImage: book.imageLinks?.secureThumbnailURL ?? "",
                                                width: geometry.size.width,
                                                height: 475)
                            .blur(radius: 20, opaque: true)
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
                        
                        Spacer()
                            .frame(height: 20)
                        
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
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                        if book.getPageCount == "0" && book.getCatagory == "N/A" {
                            Button(action: {
                                enterBothBool.toggle()
                            }) {
                                Capsule()
                                    .fill(Color.accent)
                                    .frame(width: 170, height: 35)
                                    .overlay {
                                        Capsule()
                                            .stroke(authorText.opacity(0.35), lineWidth: 1)
                                        Text("Manual Entry")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                            .accessibilityLabel("Manually Enter Book Infomation")
                                    }
                            }
                            .padding()
                            .accessibilityAddTraits(.isButton)
                        } else if book.getPageCount == "0" {
                            Button(action: {
                                enterPageCountBool.toggle()
                            }) {
                                Capsule()
                                    .fill(Color.accent)
                                    .frame(width: 230, height: 35)
                                    .overlay {
                                        Capsule()
                                            .stroke(authorText.opacity(0.35), lineWidth: 1)
                                        Text("Manually Enter Page Count")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                            .accessibilityLabel("Manually Enter Page Count")
                                    }
                            }
                            .padding()
                            .accessibilityAddTraits(.isButton)
                        } else if book.getCatagory == "N/A" {
                            Button(action: {
                                enterGenreBool.toggle()
                            }) {
                                Capsule()
                                    .fill(Color.accent)
                                    .frame(width: 230, height: 35)
                                    .overlay {
                                        Capsule()
                                            .stroke(authorText.opacity(0.35), lineWidth: 1)
                                        Text("Manually Enter Genre")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                            .accessibilityLabel("Manually Enter Genre")
                                    }
                            }
                            .padding()
                            .accessibilityAddTraits(.isButton)
                        } else {
                            Button(action: {
                                addBookToCollection()
                            }) {
                                Capsule()
                                    .fill(Color.accent)
                                    .frame(width: 200, height: 35)
                                    .overlay {
                                        Capsule()
                                            .stroke(authorText.opacity(0.35), lineWidth: 1)
                                        Text("Add To Collection")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                            .accessibilityLabel("Add Book To Collection")
                                    }
                                
                            }
                            .padding()
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.light)
        }
        .alert("Book Added", isPresented: $showAlert) {
            Button("Ok", role: .cancel, action: {
                hapticsManager.playAddedBookToCollectionHaptic()
                showingSheet = false
                bookItem = nil
            })
            .accessibilityAddTraits(.isButton)
        } message: {
            Text("\(book.title) has been added to your collection.")
                .accessibilityLabel("\(book.title) was successfully added")
        }
        
        .alert("Enter Pages and Genre", isPresented: $enterBothBool) {
            Button("Submit", action: pageAndGenreInsertion)
                .accessibilityAddTraits(.isButton)
            Button("Cancel", role: .cancel) { }
                .accessibilityAddTraits(.isButton)
            TextField("Enter Pages", text: $manualBookCount)
                .accessibilityLabel("Enter page count")
            TextField("Enter Genre", text: $enterGenre)
                .accessibilityLabel("Enter genre")
        } message: {
            Text("Please enter the total pages and genre of \(book.title).")
        }
        
        .alert("Enter Page Count", isPresented: $enterPageCountBool) {
            Button("Submit", action: pageBookInsertion)
                .accessibilityAddTraits(.isButton)
            Button("Cancel", role: .cancel) { }
                .accessibilityAddTraits(.isButton)
            TextField("Enter Total Page Count", text: $manualBookCount)
                .accessibilityLabel("Enter page count")
        } message: {
            Text("Please enter the total amount of pages in \(book.title).")
        }
        
        .alert("Enter Genre", isPresented: $enterGenreBool) {
            Button("Submit", action: genreBookInsertion)
                .accessibilityAddTraits(.isButton)
            Button("Cancel", role: .cancel) { }
                .accessibilityAddTraits(.isButton)
            TextField("Enter Genre", text: $enterGenre)
                .accessibilityLabel("Enter genre")
        } message: {
            Text("Please enter the genre of \(book.title).")
        }
        .alert("Already in Collection", isPresented: $bookIsInCollection) {
            Button("Ok", role: .cancel) { }
                .accessibilityAddTraits(.isButton)
        } message: {
            Text("This book is already in the collection.")
                .accessibilityLabel("This book is already in the collection.")
        }
        .alert("Invalid Infomation", isPresented: $invalidInfoAlert) {
            Button("Ok", role: .cancel) { }
                .accessibilityAddTraits(.isButton)
        } message: {
            Text("You have entered invalid information. Please try again.")
                .accessibilityLabel("You have entered invalid information. Please try again.")
        }
        
    }
    
    func addBookToCollection() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: book.getCatagory, pages: book.getPageCount)
        
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else {
            modelContext.insert(newBook)
            try? modelContext.save()
            bookAddedCounter += 1
            showAlert = true
        }
    }
    
    func pageBookInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: book.getCatagory, pages: manualBookCount)
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else if manualBookCount == "" || manualBookCount.isEmpty {
            invalidInfoAlert.toggle()
        } else {
            modelContext.insert(newBook)
            try? modelContext.save()
            bookAddedCounter += 1
            showAlert = true
        }
    }
    
    func genreBookInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: enterGenre, pages: book.getPageCount)
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else if enterGenre == "" || enterGenre.isEmpty {
            invalidInfoAlert.toggle()
        } else {
            modelContext.insert(newBook)
            try? modelContext.save()
            bookAddedCounter += 1
            showAlert = true
        }
    }
    
    func pageAndGenreInsertion() {
        let newBook = Book(coverImage: book.imageLinks?.secureThumbnailURL ?? "", title: book.title, author: book.getAuthor, catagory: enterGenre, pages: manualBookCount)
        if books.contains(newBook) {
            bookIsInCollection.toggle()
        } else if manualBookCount == "" || manualBookCount.isEmpty {
            invalidInfoAlert.toggle()
        } else if enterGenre == "" || enterGenre.isEmpty {
            invalidInfoAlert.toggle()
        } else {
            modelContext.insert(newBook)
            try? modelContext.save()
            bookAddedCounter += 1
            showAlert = true
        }
    }
}

#Preview {
    let example = VolumeInfo(title: "Dune", authors: ["Frank Herbert"], pageCount: 0, categories: ["N/A"])
    
    return AddView(showingSheet: .constant(false), bookItem: .constant(VolumeInfo(title: "", authors: [""], pageCount: 5, categories: [""])), book: example, books: [Book]())
}
