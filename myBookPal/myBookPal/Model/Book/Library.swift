//
//  Library.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/18/24.
//

import Foundation

struct Library {
    var books: [Book]
    
    var getInProgressOnly: [Book] {
        return books.filter { $0.completionStatus < 1}
    }
    
    var getCompletedOnly: [Book] {
        return books.filter { $0.completionStatus == 1}
    }
    
    var getMostRecentBook: Book? {
        return books.sorted(by: { $0.dateAdded > $1.dateAdded}).first
    }
}
