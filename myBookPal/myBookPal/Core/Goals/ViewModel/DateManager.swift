//
//  DateManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/23/24.
//

import Foundation

@Observable
class DateManager {
    var currentMonth = ""
    var weekDayNames: [String] = []
    var weekDayNumbers: [String] = []
    var currentDay: String = ""
    var selectedDay: String = ""
    
    func getCurrentMonth() {
        let calendar = Calendar.current
        let today = Date()
        let calendarMonth = calendar.component(.month, from: today)
        let stringForm = String(calendarMonth)
        
        switch stringForm {
        case "1":
            currentMonth = "January"
        case "2":
            currentMonth = "February"
        case "3":
            currentMonth = "March"
        case "4":
            currentMonth = "April"
        case "5":
            currentMonth = "May"
        case "6":
            currentMonth = "June"
        case "7":
            currentMonth = "July"
        case "8":
            currentMonth = "August"
        case "9":
            currentMonth = "September"
        case "10":
            currentMonth = "October"
        case "11":
            currentMonth = "November"
        case "12":
            currentMonth = "December"
        default:
            currentMonth = "Error"
        }
        
        print(currentMonth)
    }
    
    func getWeekDayNames() {
        let calendar = Calendar.current
        weekDayNames = calendar.shortWeekdaySymbols
        
        print(weekDayNames)
    }
    
    func getWeekDayNumbers() {
        let calendar = Calendar.current
        let today = Date()
        
        let weekDay = calendar.component(.weekday, from: today)
        
        let daysToSunday = weekDay - calendar.firstWeekday
        
        let startOfWeek = calendar.date(byAdding: .day, value: -daysToSunday, to: today)!
        
        var currentWeek: [Date] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                currentWeek.append(day)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        for date in currentWeek {
            let item = formatter.string(from: date)
            weekDayNumbers.append(item)
        }
        
        print(weekDayNumbers)
    }
    
    func getCurrentDay() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let item = formatter.string(from: today)
        currentDay = item
        
        print(currentDay)
    }
    
    func setSelectedDay() {
        let current = Int(currentDay)
        
        for day in weekDayNumbers {
            let intDay = Int(day)
            
            if intDay == current {
                selectedDay = day
            }
        }
        
        print(selectedDay)
    }
}
