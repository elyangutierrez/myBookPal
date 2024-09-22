//
//  DateTracker.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/17/24.
//

import Foundation

@Observable
class DateTracker {
    var displayedDates = Set<String>()
    
    func getNameOfDay() -> String {
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let day = dateFormatter.string(from: date)
        return day
    }
}
