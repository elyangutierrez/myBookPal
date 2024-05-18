//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/14/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var searchText = ""
    @Query var books: [Book]
    @State private var activateSheet = false
    
    let options = ["Ascending", "Descending"]
    @State private var selectedChoice = ""
    @AppStorage("setBookTotal") var setBookTotal = 10
    
    var searchResults: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { book in
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
                                    .font(.headline.bold())
                                if book.isFullyRead {
                                    Text("Completed")
                                        .font(.footnote)
                                } else {
                                    Text("In Progress")
                                        .font(.footnote)
                                }
                                HStack {
                                    ProgressView(value: book.completionStatus)
                                        .tint(book.completionStatus == 1 ? .green : .blue)
                                    let formatted = String(format: "%.1f", book.completionStatus * 100)
                                    Text("\(formatted)%")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteRows)
            }
            .navigationTitle("myBookPal")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        activateSheet.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.black)
                    }
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu {
//                        Picker("", selection: $selectedChoice) {
//                            ForEach(options, id: \.self) { option in
//                                Text(option)
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .foregroundStyle(.black)
//                    }
//                }
            }
            .fullScreenCover(isPresented: $activateSheet) {
                SettingsView(setBookTotal: $setBookTotal)
            }
        }
    }
    
    func deleteRows(at offsets: IndexSet) {
        for offset in offsets {
            let selection = books[offset]
            modelContext.delete(selection)
        }
    }
}

#Preview {
    ContentView()
}
