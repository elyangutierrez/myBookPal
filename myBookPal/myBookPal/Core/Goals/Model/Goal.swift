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
    var deadline: Date
    var target: Double?
    var status: String
    var reminderOn: Bool
    var priority: String
    var selectedNumber: Int
    
    init(text: String, createdOn: Date, finishedOn: Date? = nil, timeFrame: DateInterval, deadline: Date, target: Double? = nil, status: String, reminderOn: Bool, priority: String, selectedNumber: Int) {
        self.text = text
        self.createdOn = createdOn
        self.finishedOn = finishedOn
        self.timeFrame = timeFrame
        self.deadline = deadline
        self.target = target
        self.status = status
        self.reminderOn = reminderOn
        self.priority = priority
        self.selectedNumber = selectedNumber
    }
    
    var createdOnString: String {
        let date = createdOn
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    var timeCreated: String {
        let date = createdOn
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var getDeadline: String {
        let date = deadline
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}
