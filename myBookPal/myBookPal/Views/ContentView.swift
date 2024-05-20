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
//    @Query var books: [Book]
    var books: [Book]
    @State private var activateSheet = false
    
    let options = ["Ascending", "Descending"]
    @State private var selectedChoice = ""
    
    @AppStorage("setBookTotal") var setBookTotal = 10
    
    @AppStorage("getBookTotal") var getBookTotal = 0
    
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
                NavigationLink(destination: InProgressView(books: books)) {
                    Text("In Progress Only")
                }
                NavigationLink(destination: CompletedView(books: books)) {
                    Text("Completed Only")
                }
                
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
                                default:
                                    Rectangle()
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
                .onAppear {
                    getTotalBookCount(books: books)
                }
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
                SettingsView(setBookTotal: $setBookTotal, getBookTotal: $getBookTotal)
            }
        }
    }
    
    func deleteRows(at offsets: IndexSet) {
        for offset in offsets {
            let selection = books[offset]
            modelContext.delete(selection)
        }
    }
    
    func getTotalBookCount(books: [Book]) {
        getBookTotal = books.count
        print(getBookTotal)
    }
}

//#Preview {
//    ContentView(books)
//}
