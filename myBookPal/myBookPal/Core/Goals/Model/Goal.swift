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
    var deadline: Date
    var status: String
    var reminderOn: Bool
    var priority: String
    var selectedNumber: Int
    
    init(text: String, createdOn: Date, finishedOn: Date? = nil, deadline: Date, status: String, reminderOn: Bool, priority: String, selectedNumber: Int) {
        self.text = text
        self.createdOn = createdOn
        self.finishedOn = finishedOn
        self.deadline = deadline
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
