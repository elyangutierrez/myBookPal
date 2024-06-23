//
//  Goals.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/19/24.
//

import Foundation

struct Goals {
    var books: [Book]
    var booksCompleted: [Book] = []
    
    mutating func addCompletedBooksToArray(_ books: [Book]) -> Int {
        let completed = books.filter { $0.isFullyRead }
        booksCompleted.append(contentsOf: completed)
        
        return booksCompleted.count
        
    }
    
    func checkCompletionStatus(_ books: [Book]) -> Int {
        var count = 0
        for book in books {
            if book.isFullyRead {
                count += 1
            }
        }
        return count
    }
    
    func getTotalBookCount(_ books: [Book]) -> Int {
        return books.count
    }
}
