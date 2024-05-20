//
//  Goals.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/19/24.
//

import Foundation

struct Goals {
    var books: [Book]
    
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
