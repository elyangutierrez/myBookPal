//
//  ManualFormView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/30/24.
//

import SwiftUI
import PhotosUI

struct ManualFormView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var coverImage: String = ""
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var genre: String = ""
    @State private var pages: String = ""
    @State private var dateAdded = Date.now
    @State private var successfulAlert = false
    @State private var unsuccessfulAlert = false
    @State private var pictureHandler = PictureHandler()
    @State private var showCameraPicker = false
    
    var collectionBooks: [Book]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Title", text: $title, prompt: Text("Enter book name"))
                }
                
                Section("Primary Author") {
                    TextField("Author", text: $author, prompt: Text("Enter author"))
                }
                
                Section("Genre") {
                    TextField("Genre", text: $genre, prompt: Text("Enter genre"))
                }
                
                Section("Page Count") {
                    TextField("Page", text: $pages, prompt: Text("Enter page count"))
                }
                
                Section("Book Cover Image") {
                    
                    Button(action: {
                        showCameraPicker.toggle()
                    }) {
                        Text("Take Picture")
                    }
                    
                    Button(action: {
                        pictureHandler.showPhotosPicker.toggle()
                    }) {
                        Text("Select from Gallery")
                    }
                    
                    pictureHandler.displayedImage?
                        .resizable()
                        .frame(width: 150, height: 210)
                        .scaledToFill()
                }
                
//                Button(action: {
//                    addBookToCollection()
//                    print("tapped!")
//                }) {
//                    Text("Add Book")
//                }
//                .disabled(pictureHandler.displayedImage == nil || title.isEmpty || genre.isEmpty || author.isEmpty || pages.isEmpty)
                
                Section {
                    Button(action: {
                        addBookToCollection()
                    }) {
                        Text("Add Book")
                    }
                    .disabled(pictureHandler.displayedImage == nil || title.isEmpty || genre.isEmpty || author.isEmpty || pages.isEmpty)
                } header: {
                    Text("")
                } footer: {
                    Text("Warning: Manually adding books to your collection may cause lag or performance issues as it was not intended to be manually added but rather with isbn or online.")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Manual Entry")
                        .foregroundStyle(.accent)
                        .fontWeight(.semibold)
                }
            }
            .photosPicker(isPresented: $pictureHandler.showPhotosPicker, selection: $pictureHandler.pickerItem, matching: .images)
            .onChange(of: pictureHandler.pickerItem) {
                Task {
                    await pictureHandler.convertPickerItemToImage()
                }
            }
            .fullScreenCover(isPresented: $showCameraPicker) {
                CameraPickerView { image in
                    pictureHandler.convertUIImageToImage(image: image)
                }
                .ignoresSafeArea()
            }
        }
        .alert("Book Added", isPresented: $successfulAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("\(title) has been added to your collection.")
        }
        .alert("Failed To Add Book", isPresented: $unsuccessfulAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Please try again.")
        }
    }
    
    func addBookToCollection() {
        
        coverImage = pictureHandler.convertedString!
        print("Value of coverImage: \(coverImage)")
        let book = Book(coverImage: coverImage, title: title, author: author, catagory: genre, pages: pages)
        
        
        
        if collectionBooks.contains(book) {
            unsuccessfulAlert.toggle()
        } else {
            modelContext.insert(book)
            successfulAlert.toggle()
        }
    }
}

#Preview {
    ManualFormView(collectionBooks: [Book(coverImage: "", title: "", author: "", catagory: "", pages: "")])
}
