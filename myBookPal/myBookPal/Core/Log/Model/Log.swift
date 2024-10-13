//
//  Log.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/13/24.
//

import SwiftData
import Foundation

@Model
class Log: Identifiable {
    var id = UUID()
    var currentPage: String
    var dateLogged: Date
    var quickNote: QuickNote?
    var showingNote: Bool
    
    var totalPagesRead: Int {
        return Int(currentPage) ?? 0
    }
    
    var getMonthAndDay: String {
        let date = dateLogged
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,"
        return formatter.string(from: date)
    }
    
    var getYear: String {
        let date = dateLogged
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    
    var getFormattedDate: String {
        let date = dateLogged
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    var getTime: String {
        let date = dateLogged
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var getFullDate: String {
        let date = dateLogged
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    init(id: UUID = UUID(), currentPage: String, dateLogged: Date, quickNote: QuickNote? = nil, showingNote: Bool) {
        self.id = id
        self.currentPage = currentPage
        self.dateLogged = dateLogged
        self.quickNote = quickNote
        self.showingNote = showingNote
    }
}
