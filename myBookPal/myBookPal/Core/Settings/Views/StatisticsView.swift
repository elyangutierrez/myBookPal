//
//  StatisticsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/19/24.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    var totalBooksCount = 4
    var inProgressCount = 2
    var completed = 2
    
    var books: [Book]

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
//                    Color.white
//                        .frame(height: 275)
                    
                    let allBooks = Library(books: books)
                    
                    var getCount: Int {
                        return allBooks.getTotalBookCount
                    }
                    
                    var getIPOnly: Int {
                        var count = 0
                        
                        if allBooks.getInProgressOnly == [] {
                            return 0
                        } else {
                            for _ in allBooks.getInProgressOnly {
                                count += 1
                            }
                        }
                        
                        return count
                    }
                    
                    var getCOnly: Int {
                        var count = 0
                        
                        if allBooks.getCompletedOnly == [] {
                            return 0
                        } else {
                            for _ in allBooks.getCompletedOnly {
                                count += 1
                            }
                        }
                        
                        return count
                    }
                    
                    if getIPOnly == 0 {
                        VStack {
//                            Spacer()
//                                .frame(height: 120)
                            
                            ContentUnavailableView() {
                                Label("No Statistics Avaliable", systemImage: "book.closed.fill")
                            } description: {
                                Text("Statistics are avaliable when one book is in progress.")
                            }
                        }
                    } else {
                        
                        VStack {
//                            Spacer()
//                                .frame(height: 80)
                            
                            DonutChartView(totalBooksCount: getCount, booksRead: getCOnly, booksInProgress: getIPOnly)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Statistics")
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
}

//#Preview {
//    StatisticsView(books: book)
//}
