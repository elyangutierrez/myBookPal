//
//  Group.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/19/24.
//

import Foundation
import SwiftData

@Model
class Group {
    var id = UUID()
    var name: String
    var books: [Book]?
    var creationDate: Date
    
    var formattedDate: String {
        let date = creationDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
        
    }
    
    init(name: String, creationDate: Date) {
        self.name = name
        self.books = nil
        self.creationDate = creationDate
    }
}
