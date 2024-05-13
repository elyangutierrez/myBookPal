//
//  AddView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftUI

struct AddView: View {
    var book: VolumeInfo

    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: 15)
                    BookCoverView(bookImage: book.imageLinks?.secureThumbnailURL ?? "")
                        .frame(width: 250, height: 310)
                    RectangleLineView()
                        .padding()
                }
                
                VStack(alignment: .leading) {
                    Section {
                        Text(book.title)
                            .fixedSize(horizontal: true, vertical: false)
                            .font(.title.bold())
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    
                    Section {
                        Text("by: \(book.getAuthor)")
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    
                    Section {
                        HStack {
                            Image("open-book-2")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("\(book.getPageCount) pages")
                        }
                        .padding(.bottom, 5)
                    }
                    Spacer()
                    
                    Section {
                        Button(action: {
                            addBookToCollection()
                        }) {
                            Capsule()
                                .fill(.gray.opacity(0.30))
                                .frame(width: 150, height: 35)
                                .overlay {
                                    Text("Add To Collection")
                                        .foregroundStyle(.black)
                                }
                        }
                    }
                }
                .padding(5)
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
        showAlert.toggle()
    }
}

#Preview {
    let example = VolumeInfo(title: "Dune", authors: ["Frank Herbert"], pageCount: 345, categories: ["Fiction"])
    
    return AddView(book: example)
}
