//
//  Book.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftData
import Foundation

@Model
class Book: Identifiable, Equatable {
    var coverImage: String
    var title: String
    var author: String
    var catagory: String
    var pages: String
    var dateAdded: Date
    var logs: [Log]?
    var starRatingSystem: StarRating?
    var isMostRecentlyViewed: Bool?
    
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
    
    var getLogCount: Int? {
        guard let logs = logs else {
            return nil
        }
        return logs.count
    }
    
    var getLogCreationDate: String {
        guard let logs = logs else {
            return ""
        }
        
        return logs.first?.getFullDate ?? "No Date Avaliable"
    }
    
    func addLogEntry(_ log: Log) {
        if logs == nil {
            logs = [log]
        } else {
            logs?.append(log)
        }
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author && lhs.catagory == rhs.catagory && lhs.pages == rhs.pages
    }
    
    init(coverImage: String, title: String, author: String, catagory: String, pages: String, dateAdded: Date = Date()) {
        self.coverImage = coverImage
        self.title = title
        self.author = author
        self.catagory = catagory
        self.pages = pages
        self.dateAdded = dateAdded
        self.logs = nil
        self.starRatingSystem = nil
        self.isMostRecentlyViewed = nil
    }
}
