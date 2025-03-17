// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class MCalendarManager {
    weak var vc: MCalendarView?
    var selectedDay = Date.now {
        didSet {
            updateFirstWeekday()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                vc?.collectionView.reloadData()
                vc?.yearMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: selectedDay)
            }
        }
    }
    var curFirstWeekday: Int = 0

    init() {
        updateFirstWeekday()
    }
}

// MARK: - Date
extension MCalendarManager {
    func firstWeekday(ofYear year: Int, month: Int) -> Int {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        if let firstDay = calendar.date(from: components) {
            // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
            return calendar.component(.weekday, from: firstDay)
        }
        return -1
    }

    func getYearAndMonth() -> (Int, Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDay)
        let month = calendar.component(.month, from: selectedDay)
        return (year, month)
    }

    func updateFirstWeekday() {
        let (year, month) = getYearAndMonth()
        curFirstWeekday = firstWeekday(ofYear: year, month: month) - 1
    }

    func daysInMonth() -> Int? {
        let calendar = Calendar.current
        let (year, month) = getYearAndMonth()
        let dateComponents = DateComponents(year: year, month: month)
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count + curFirstWeekday
        }
        return nil
    }

    func getCollectionViewDate(index: Int) -> String {
        if index < curFirstWeekday { return "" }
        return "\(index - curFirstWeekday + 1)"
    }
}
