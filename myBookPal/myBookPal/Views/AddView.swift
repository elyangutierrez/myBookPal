//
//  AddView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var author = ""
    
    let genres = ["Fantasy", "Historical Fiction", "Thriller", "Romance", "Science Fiction",
                  "Mystery", "Poetry", "Drama", "Non Fiction", "Other"].sorted()
    
    @State private var genre = "Non Fiction"
    @State private var page = 0
    @State private var dateSelection = Date.now
    
    var checkFields: Bool {
        if name.isEmpty || author.isEmpty || genre.isEmpty || page == 0 {
            return true
        }
        return false
    }
    
    @State private var alertConfimation = false
    
    let nextDay = Date.now.addingTimeInterval(86400)
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Book Details") {
                    TextField("Book Name", text: $name)
                    TextField("Book Author", text: $author)
                }
                
                Section("Genre") {
                    Picker("Book Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Page Number") {
                    TextField("Book Page", value: $page, format: .number)
                }
                
                Section("Date/Time Read") {
                    DatePicker("Datetime", selection: $dateSelection, in: Date.now...nextDay)
                }
                
                Button(action: {
                    insertBookToModel()
                }) {
                    Text("Add Book")
                }
                .disabled(checkFields)
                
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("Successfully Added", isPresented: $alertConfimation) {
            Button("Ok", action: resetView)
        } message: {
            Text("Your book has been successfully added to the collection.")
        }
    }
    
    func insertBookToModel() {
        let book = Book(id: UUID(), name: name, author: author, genre: genre, page: page, date: dateSelection)
        modelContext.insert(book)
        alertConfimation = true
    }
    
    func resetView() {
        name = ""
        author = ""
        genre = "Non Fiction"
        page = 0
        alertConfimation = false
    }
}

#Preview {
    AddView()
}
