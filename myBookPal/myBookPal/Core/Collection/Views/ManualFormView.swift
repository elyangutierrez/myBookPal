//
//  ManualFormView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/30/24.
//

import SwiftUI
import PhotosUI

struct ManualFormView: View {
    
    @Environment(\.dismiss) var dismiss
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
    @State private var hapticsManager = HapticsManager()
    
    var collectionBooks: [Book]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Title", text: $title, prompt: Text("Enter book name"))
                        .accessibilityLabel("Enter book title")
                }
                
                Section("Primary Author") {
                    TextField("Author", text: $author, prompt: Text("Enter author"))
                        .accessibilityLabel("Enter book author")
                }
                
                Section("Genre") {
                    TextField("Genre", text: $genre, prompt: Text("Enter genre"))
                        .accessibilityLabel("Enter book genre")
                }
                
                Section("Page Count") {
                    TextField("Page", text: $pages, prompt: Text("Enter page count"))
                        .accessibilityLabel("Enter book page count")
                }
                
                Section("Book Cover Image") {
                    
                    Button(action: {
                        showCameraPicker.toggle()
                    }) {
                        Text("Take Picture")
                            .accessibilityLabel("Take picture of book cover")
                    }
                    
                    Button(action: {
                        pictureHandler.showPhotosPicker.toggle()
                    }) {
                        Text("Select from Gallery")
                            .accessibilityLabel("Select book cover from gallery")
                    }
                    
                    pictureHandler.displayedImage?
                        .resizable()
                        .frame(width: 150, height: 210)
                        .scaledToFill()
                }
                
                Section {
                    Button(action: {
                        addBookToCollection()
                    }) {
                        Text("Add Book")
                            .accessibilityLabel("Add Book")
                    }
                    .accessibilityAddTraits(.isButton)
                    .disabled(pictureHandler.displayedImage == nil || title.isEmpty || genre.isEmpty || author.isEmpty || pages.isEmpty)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Manual Entry")
                        .foregroundStyle(.accent)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .accessibilityLabel("Exit manual entry")
                    }
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
            Button("Ok", role: .cancel, action: {
                hapticsManager.playAddedBookToCollectionHaptic()
                dismiss()
            })
            .accessibilityAddTraits(.isButton)
        } message: {
            Text("\(title) has been added to your collection.")
                .accessibilityLabel("The book has been successfully added")
        }
        .alert("Failed To Add Book", isPresented: $unsuccessfulAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Please try again.")
                .accessibilityLabel("The book could not be added")
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
