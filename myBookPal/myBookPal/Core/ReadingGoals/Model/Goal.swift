//
//  Goals.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import Foundation
import SwiftData

@Model
class Goal {
    var text: String
    var createdOn: Date
    var finishedOn: Date?
    var timeFrame: DateInterval
    var target: Int
    var status: String
    var reminderOn: Bool
    var priority: String
    
    init(text: String, createdOn: Date, finishedOn: Date? = nil, timeFrame: DateInterval, target: Int, status: String, reminderOn: Bool, priority: String) {
        self.text = text
        self.createdOn = createdOn
        self.finishedOn = finishedOn
        self.timeFrame = timeFrame
        self.target = target
        self.status = status
        self.reminderOn = reminderOn
        self.priority = priority
    }
    
    var createdOnString: String {
        let date = createdOn
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}
