//
//  RecentlyViewedBook.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/7/24.
//

import Foundation

class RecentlyViewedBook: Identifiable, Equatable, Codable {
    static func == (lhs: RecentlyViewedBook, rhs: RecentlyViewedBook) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author && lhs.catagory == rhs.catagory && lhs.pages == rhs.pages
    }
    
    let coverImage: String
    let title: String
    let author: String
    let catagory: String
    let pages: String
    let dateAdded: Date
    var logs: [Log]?
    var starRatingSystem: StarRating?
    
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
    
    func addLogEntry(_ log: Log) {
        if logs == nil {
            logs = [log]
        } else {
            logs?.append(log)
        }
    }
    
    func convertToBook() -> Book {
        return Book(coverImage: self.coverImage, title: self.title, author: self.author, catagory: self.catagory, pages: self.pages, dateAdded: self.dateAdded)
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
    }
}
