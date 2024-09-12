//
//  NotificationsModel.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import Foundation
import Observation
import UserNotifications

@Observable
class NotificationsModel {
    
    func userNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.scheduleNotifications()
            } else if let error = error {
                print("Notification Error: \(error)")
            }
        }
    }
    
    func scheduleNotifications() {
        
        let randomNumber = Int.random(in: 0..<3)
        var date = DateComponents()
        
        let hours = [8,12,17]
        
        date.hour = hours[randomNumber]
        date.minute = 30
        
        print("Notifications enabled.")
        
        let content = UNMutableNotificationContent()
        let notificationContents = [
            ("Have you read today? 👀", "Don't forget to log your reading."),
            ("Time to read! ⏰", "How far have you gotten in your current book?"),
            ("Reading reminder 🗒️", "Log your reading progress now!")
        ]
        
        content.title = notificationContents[randomNumber].0
        content.body = notificationContents[randomNumber].1
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let nextDate = trigger.nextTriggerDate()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending request: \(error.localizedDescription)")
            } else {
                print("Nofication Scheduled!")
                print(nextDate!)
            }
        }
    }
}
