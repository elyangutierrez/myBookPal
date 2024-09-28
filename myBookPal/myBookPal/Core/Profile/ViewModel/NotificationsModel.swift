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
class NotificationsModel: @unchecked Sendable {
    
    var dailyNotificationsIdenifier = UUID().uuidString
    var nextDate = Date()
    
    func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Nofications Enabled")
            } else if let error = error {
                print("Notification Error: \(error)")
            }
        }
    }
    
    func sendDailyNotifications() async {
        let content = UNMutableNotificationContent()
        content.title = "Have you read today? 👀"
        content.body = "Don't forget to log your reading!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: dailyNotificationsIdenifier, content: content, trigger: trigger)
        
        print("Got request!")
        
        // Schedule the request with the system
        let notificationCenter = UNUserNotificationCenter.current()
        do {
            try await notificationCenter.add(request)
            print("Added request!")
            print("Next day to be triggered \(trigger.nextTriggerDate()!)")
            nextDate = trigger.nextTriggerDate()!
        } catch {
            print("Error adding request: \(error)")
        }
        
    }
    
    func cancelDailyNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyNotificationsIdenifier])
        print("Canceled all daily notifications!")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Notification was triggered, schedule the next one
        print("Notification triggered, scheduling next one...")
        Task {
            await self.sendDailyNotifications()
        }
        completionHandler()
    }

}
