//
//  Book.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftData
import Foundation

@Model
class Book: Identifiable {
    let coverImage: String
    let title: String
    let author: String
    let catagory: String
    let pages: String
    var logs: [Log]?
    
    var totalPagesRead: Int {
        guard let logs = logs else {
            return 0
        }
        return logs.reduce(0) {$0 + $1.totalPagesRead}
        // starts with initial value of 0 and $0 represents the sum. $1.totalPagesRead is then added to the sum.
    }
    
    var isFullyRead: Bool {
        return totalPagesRead == Int(pages)
    }
    
    var currentPage: Int {
        guard let logs = logs else {
            return 0
        }
        return logs.last?.totalPagesRead ?? 0
    }
    
    var completionStatus: Double {
        guard let totalPages = Double(pages) else { return 0 }
        let status = Double(currentPage) / totalPages
        return status
    }
    
    func addLogEntry(_ log: Log) {
        if logs == nil {
            logs = [log]
        } else {
            logs?.append(log)
        }
    }
    
    init(coverImage: String, title: String, author: String, catagory: String, pages: String) {
        self.coverImage = coverImage
        self.title = title
        self.author = author
        self.catagory = catagory
        self.pages = pages
        self.logs = nil
    }
}
