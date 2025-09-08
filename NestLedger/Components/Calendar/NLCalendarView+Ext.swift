// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension NLCalendarView {
    static func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        if let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
            return firstDayOfMonth
        }
        return .now
    }

    static func dayStart(date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}

extension NLCalendarView {
    func getNumberOfDayCells() -> Int {
        let weekday = calendar.component(.weekday, from: month)
        if let range = calendar.range(of: .day, in: .month, for: month) {
            return range.count + weekday - 1
        }
        return 30 + weekday - 1
    }

    func getDayCellDay(idx: Int) -> Int {
        let weekday = calendar.component(.weekday, from: month)
        if idx < weekday - 1 {
            return -1
        }
        return idx - (weekday - 1) + 1
    }

    func isDaySelected(idx: Int) -> Bool {
        let weekday = calendar.component(.weekday, from: month)
        if idx < weekday - 1 {
            return false
        }
        let currentDay = idx - (weekday - 1) + 1
        var currentDate = calendar.dateComponents([.year, .month], from: month)
        currentDate.day = currentDay
        if let currentDate = calendar.date(from: currentDate),
           currentDate == selectedDay {
            return true
        }
        return false
    }
}
