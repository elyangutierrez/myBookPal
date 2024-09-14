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
    
    var isNotifAuthGiven: Bool = UserDefaults.standard.bool(forKey: "isNotifAuthGiven")
    var notificationsTime: Date = UserDefaults.standard.object(forKey: "notificationsTime") as? Date ?? Date()
    var isNotificationsOn: Bool = UserDefaults.standard.bool(forKey: "isNotificationsOn")
    
    func enableNotifications() {
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
        
        date.hour = 11
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
        
//        let nextDate = trigger.nextTriggerDate()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending request: \(error.localizedDescription)")
            } else {
                print("Nofication Scheduled!")
            }
        }
        
        self.saveNotifTime()
        self.saveNotificationStatus()
    }
    
    func removeDailyNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.saveNotifTime()
        self.saveNotificationStatus()
        
        print("DEBUG: Notifications removed.")
    }
    
    func saveNotificationStatus() {
        UserDefaults.standard.set(isNotificationsOn, forKey: "isNotificationsOn")
    }

    func saveNotifAuthStatus() {
        UserDefaults.standard.set(isNotifAuthGiven, forKey: "isNotifAuthGiven")
    }
    func saveNotifTime() {
        UserDefaults.standard.set(notificationsTime, forKey: "notificationsTime")
    }
}
