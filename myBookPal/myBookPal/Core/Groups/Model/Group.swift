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
    var name: String
    var books: [Book]?
    var creationDate: Date
    var imageData: Data?
    
    var formattedDate: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/d/yyyy"
        return dateFormatter.string(from: date)
        
    }
    
    init(name: String, creationDate: Date, imageData: Data? = nil) {
        self.name = name
        self.books = nil
        self.creationDate = creationDate
        self.imageData = imageData
    }
}
