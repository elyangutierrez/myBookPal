//
//  YearlyReadingGoals.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/21/24.
//

import Foundation

struct YearlyReadingGoals: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var booksRead: Int
}
