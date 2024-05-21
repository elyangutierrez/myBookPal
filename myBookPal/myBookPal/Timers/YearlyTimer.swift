//
//  YearlyTimer.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/21/24.
//

import Foundation

func timeRemainingInYear() -> TimeInterval {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.year, .month], from: now)
    
    guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: calendar.date(from: components)!) else {
        return 0
    }
    
    let endOfYear = calendar.date(byAdding: .second, value: -1, to: startOfNextYear)!
    
    return endOfYear.timeIntervalSince(now)
}
