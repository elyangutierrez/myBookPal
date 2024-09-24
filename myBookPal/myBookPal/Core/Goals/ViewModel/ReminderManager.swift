//
//  ReminderManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import Foundation

@Observable
class ReminderManager {
    /* This class will handle with reminders being sent out
       on the behalf of the user if they have allowed */
    
    var startDate = Date()
    var endDate = Date()
    var notificationTitle = ""
    var notificationMessage = ""
}
