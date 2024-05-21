//
//  MonthlyReadingGoals.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/21/24.
//

import Foundation

struct MonthlyReadingGoals: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var booksRead: Int
}
