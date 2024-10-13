//
//  QuickNote.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/21/24.
//

import Foundation
import SwiftData

@Model
class QuickNote: Identifiable {
    var id = UUID()
    var noteText: String
    var date: Date
    
    init(id: UUID = UUID(), noteText: String, date: Date) {
        self.id = id
        self.noteText = noteText
        self.date = date
    }
    
    var shortenedDate: String {
        let date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}
