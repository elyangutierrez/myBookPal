//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/8/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    @State private var searchText = ""
    @State private var toggleSettingsView = false
    
    var body: some View {
        NavigationStack {
            if !books.isEmpty {
                List {
                    ForEach(books, id: \.self) { book in
                        NavigationLink(destination: DetailView(book: book)) {
                            VStack(alignment: .leading) {
                                Text(book.name)
                                    .font(.headline)
                                Text(book.formattedDate)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: removeList)
                }
                .navigationTitle("myBookPal")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            toggleSettingsView.toggle()
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .fullScreenCover(isPresented: $toggleSettingsView) {
                    SettingsView()
                }
            } else {
                VStack {
                    EmptyCollectionView()
                }
                .navigationTitle("myBookPal")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            toggleSettingsView.toggle()
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .fullScreenCover(isPresented: $toggleSettingsView) {
                    SettingsView()
                }
            }
        }
    }
    
    func removeList(at offsets: IndexSet) {
        for offset in offsets {
            let selectedBook = books[offset]
            modelContext.delete(selectedBook)
            
        }
    }
}

#Preview {
    ContentView()
}
