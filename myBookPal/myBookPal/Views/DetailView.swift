//
//  DetailView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    var book: Book
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: 15)
                    ZStack {
                        Rectangle()
                            .frame(width: 260, height: 360)
                            .foregroundStyle(.clear)
                            .border(.black, width: 5)
                            .shadow(radius: 10)
                        VStack {
                            Image("testCoverImage")
                                .resizable()
                                .frame(width: 250, height: 350)
                        }
                    }
                    RectangleLine()
                    
                }
                HStack {
                    VStack(alignment: .leading) {
                        BookInfoRowView(title: "Book Name", value: book.name)
                        Spacer()
                            .frame(height: 30)
                        BookInfoRowView(title: "Book Author", value: book.author)
                        Spacer()
                            .frame(height: 30)
                        BookInfoRowView(title: "Book Genre", value: book.genre)
                        Spacer()
                            .frame(height: 30)
                        BookInfoRowView(title: "Book Page", value: "\(book.page)")
                        Spacer()
                            .frame(height: 30)
                    }
                }
                
                RectangleLine()
                    .offset(y: -20)
            }
            .navigationTitle("Book Info")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(id: UUID(), name: "Dune", author: "Frank Herbert", genre: "Science Fiction", page: 453, date: Date.now)
        
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Sorry, this couldn't be previewed: \(error.localizedDescription).")
    }
}
