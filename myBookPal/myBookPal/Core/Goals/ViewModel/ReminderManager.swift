//
//  ReminderManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import Foundation
import SwiftData
import UserNotifications

@Observable
class ReminderManager: @unchecked Sendable {
    /* This class will handle with reminders being sent out
       on the behalf of the user if they have allowed */
    
    var goalTitle: String?
    var reminderDate: Date?
    
    var center = UNUserNotificationCenter.current()
    
    init(goalTitle: String? = nil, reminderDate: Date? = nil) {
        self.goalTitle = goalTitle
        self.reminderDate = reminderDate
    }
    
    func checkIfNotificationsAreEnabled() async {
        do {
            try await center.requestAuthorization(options: [.alert, .badge, .sound, .provisional])
        } catch {
            print(error)
        }
    }
    
    func createNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(goalTitle!)"
        content.body = "Don't forgot to finish your goal! ⏰"
        
        let dateComps = Calendar.current.dateComponents([.day, .hour, .minute], from: reminderDate!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
}
