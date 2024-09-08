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
    @State private var isStarRatingAlertOn = false
    @State private var inputRating: Double?
    
    var book: Book

    var body: some View {
        NavigationStack {
            VStack {
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
            .preferredColorScheme(.dark)
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: book.logs) {
                if book.isFullyRead {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isStarRatingAlertOn = true
                    }
                }
            }
            .toolbar {
                
                if book.getLogCount != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        Button(action: {
                            isStarRatingAlertOn.toggle()
                        }) {
                            Image(systemName: "star")
                        }
                        .padding(.horizontal, -10)
                    }
                }
                
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
            .alert("Rate Book", isPresented: $isStarRatingAlertOn) {
                TextField("Enter Rating", value: $inputRating, format: .number)
                Button("Add", action: addRatingToBook)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter a rating from 0 to 5.")
            }
        }
    }
    
    func addRatingToBook() {
        
        // TODO: Find way to get book rating to match input rating..
        
        isStarRatingAlertOn = false
        
        let starRating = StarRating(rating: inputRating ?? 0.0)
        book.starRatingSystem = starRating
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
