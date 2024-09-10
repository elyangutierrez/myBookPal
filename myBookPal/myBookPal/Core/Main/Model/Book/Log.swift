//
//  Log.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/13/24.
//

import SwiftData
import Foundation

struct Log: Hashable, Codable, Identifiable {
    var id = UUID()
    let currentPage: String
    let dateLogged: Date
    
    var totalPagesRead: Int {
        return Int(currentPage) ?? 0
    }
    
    var formattedDate: String {
        let date = dateLogged
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
