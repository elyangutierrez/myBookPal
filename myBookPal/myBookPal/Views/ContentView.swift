//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/8/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var toggleSettingsView = false
    
    @Environment(\.modelContext) var modelContext
    @Query var collection: [Book]

    var body: some View {
        NavigationStack {
            List {
                ForEach(collection, id: \.self) { book in
                    NavigationLink(destination: LogView(book: book)) {
                        HStack {
                            AsyncImage(url: URL(string: book.coverImage)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 90)
                                case .failure(let error):
                                    let _ = print("Image error", error)
                                    Color.red
                                case .empty:
                                    Rectangle()
                                @unknown default:
                                    fatalError()
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(book.title)
                            }
                            
                        }
                    }
                }
                .onDelete(perform: deleteBook)
            }
            .navigationTitle("myBookPal")
            .searchable(text: $searchText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        toggleSettingsView.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .tint(.black)
                    }
                }
            }
            .fullScreenCover(isPresented: $toggleSettingsView) {
                SettingsView()
            }
        }
    }
    
    func deleteBook(at offsets: IndexSet) {
        for offset in offsets {
            let book = collection[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
