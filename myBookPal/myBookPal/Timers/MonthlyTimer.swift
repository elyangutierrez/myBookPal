//
//  MonthlyTimer.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/21/24.
//

import Foundation

func timeRemainingInMonth() -> TimeInterval {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.year, .month], from: now)
    
    guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: calendar.date(from: components)!) else {
        return 0
    }
    
    let endOfMonth = calendar.date(byAdding: .second, value: -1, to: startOfNextMonth)!
    
    return endOfMonth.timeIntervalSince(now)
}
