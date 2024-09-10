//
//  CompletedView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/18/24.
//

import SwiftData
import SwiftUI

struct CompletedView: View {
    var books: [Book]
    
    var body: some View {
        NavigationStack {
            List {
                let library = Library(books: books)
                ForEach(library.getCompletedOnly, id: \.self) { book in
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
            }
//            .navigationTitle("In Progress")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    CompletedView(books: <#T##[Book]#>)
//}
