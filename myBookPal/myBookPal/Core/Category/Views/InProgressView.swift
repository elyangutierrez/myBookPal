//
//  InProgressView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/18/24.
//

import SDWebImageSwiftUI
import SwiftData
import SwiftUI

struct InProgressView: View {
    var books: [Book]
    
    var body: some View {
        NavigationStack {
            List {
                let library = Library(books: books)
                ForEach(library.getInProgressOnly, id: \.self) { book in
                    NavigationLink(destination: LogView(book: book)) {
                        HStack {
                            WebImage(url: URL(string: book.coverImage)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                            } placeholder: {
                                Rectangle()
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
//    do {
//        
//    } catch {
//        return Text("Couldn't preview.")
//    }
//    
//    
//    InProgressView(books: <#T##[Book]#>)
//}
