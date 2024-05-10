//
//  Book.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import Foundation

@Model
class Book {
    var id: UUID
    let name: String
    let author: String
    let genre: String
    let page: Int
    let date: Date

    init(id: UUID, name: String, author: String, genre: String, page: Int, date: Date) {
        self.id = id
        self.name = name
        self.author = author
        self.genre = genre
        self.page = page
        self.date = date
    }
    
    var formattedDate: String {
        let someDate = date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let newDate = formatter.string(from: someDate)
        return newDate
    }
}
