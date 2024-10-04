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
    @State private var selectedBook: Book?
    var books: [Book]
    
    var adaptiveColumn = [
        GridItem(.adaptive(minimum: 165), spacing: -15)
    ]
    
    var getInProgressOnly: [Book] {
        let library = Library(books: books)
        return library.getInProgressOnly
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer()
                    .frame(height: 30)
                LazyVGrid(columns: adaptiveColumn, spacing: 5) {
                    ForEach(getInProgressOnly, id: \.self) { book in
                        Rectangle()
                            .fill(.white)
                            .frame(width: 150, height: 350)
                            .overlay {
                                VStack {
                                    WebImage(url: URL(string: book.coverImage)) { image in
                                        image
                                            .CategoryImageExtension()
                                    } placeholder: {
                                        VStack {
                                            ProgressView()
                                            
                                            Spacer()
                                                .frame(height: 70)
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Spacer()
                                        .frame(height: 220)
                                    Text(book.title)
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .lineLimit(2)
                                    Spacer()
                                        .frame(height: 5)
                                    HStack {
                                        ProgressView(value: book.completionStatus)
                                            .tint(book.completionStatus == 1 ? .green : .blue)
                                        let formatted = String(format: "%.1f", book.completionStatus * 100)
                                        Text("\(formatted)%")
                                            .font(.subheadline)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 200, alignment: .leading)
                                .padding(.horizontal, 5)
                            }
                            .onTapGesture {
                                selectedBook = book
                            }
                    }
                }
            }
            .accessibilityHint("Books in progress: \(getInProgressOnly.count)")
            .navigationDestination(item: $selectedBook) { book in
                LogView(book: book)
            }
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
