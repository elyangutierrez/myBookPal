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
    
    var book: Book

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(book.logs ?? [Log](), id: \.self) { log in
                        VStack(alignment: .leading) {
                            Text(log.formattedDate)
                                .font(.headline.bold())
//                            HStack {
//                                Text(log.currentPage)
//                                Image("open-book-2")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                            }
                            HStack {
                                Image(systemName: "book.circle")
                                Text("\(log.totalPagesRead) / \(book.pages)")
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
                        Text("Add Log")
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                AddLogEntryView(book: book)
            }
        }
    }
}

//#Preview {
//    LogView(book)
//}
