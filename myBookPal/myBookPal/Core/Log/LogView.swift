//
//  LogView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftData
import SwiftUI

struct LogView: View {
    @State private var showSheet = false
    @State private var activateReviewSheet = false
    
    var book: Book

    var body: some View {
        NavigationStack {
            VStack {
//                let _ = print(book.getLogCount)
                if book.getLogCount == nil {
                    ContentUnavailableView("No Logs Avaliable", 
                                           systemImage: "book.pages",
                                           description: Text("Click the '+' to add a log!"))
                    
                } else {
                    List {
                        ForEach(book.logs ?? [Log](), id: \.self) { log in
                            VStack(alignment: .leading) {
                                Text(log.formattedDate)
                                    .font(.headline.bold())
                                HStack {
                                    Image(systemName: "book.circle")
                                    Text("\(log.totalPagesRead) / \(book.pages)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                AddLogEntryView(book: book)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(coverImage: "AAAA", title: "Dune", author: "Frank Herbert", catagory: "Fiction", pages: "706")
        return LogView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Sorry, couldn't preview.")
    }
}
