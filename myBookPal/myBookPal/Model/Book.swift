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
    let pages: String
    var logs: [Log]?
    
    func addLogEntry(_ log: Log) {
        if logs == nil {
            logs = [log]
        } else {
            logs?.append(log)
        }
    }
    
    init(coverImage: String, title: String, author: String, pages: String) {
        self.coverImage = coverImage
        self.title = title
        self.author = author
        self.pages = pages
        self.logs = nil
    }
}
