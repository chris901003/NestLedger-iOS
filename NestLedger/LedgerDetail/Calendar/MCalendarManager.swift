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
    // 這裡的 key 應該是 string 才對
    var dayAmount: [Date: Int] = [:]
    var dayTransactions: [Date: [TransactionData]] = [:]

    let ledgerId: String
    let apiManager = APIManager()

    init(ledgerId: String) {
        self.ledgerId = ledgerId
        updateFirstWeekday()
        Task {
            try? await getTransactions()
        }
    }

    func getTransactions() async throws {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: selectedDay)
        components.month = Calendar.current.component(.month, from: selectedDay)
        components.day = 1
        guard let startDate = Calendar.current.date(from: components) else { return }
        components.day = Calendar.current.range(of: .day, in: .month, for: startDate)?.count
        guard let endDate = Calendar.current.date(from: components) else { return }

        let taipeiTimeZone = TimeZone(secondsFromGMT: 60 * 60 * 8)! // +8
        var calendar = Calendar.current
        calendar.timeZone = taipeiTimeZone

        let transactions = try await apiManager.getTransactionByLedger(config: .init(
            ledgerId: ledgerId,
            startDate: startDate,
            endDate: endDate
        ))
        for transaction in transactions {
            let date = calendar.component(.day, from: transaction.date)
            dayTransactions[transaction.date, default: []].append(transaction)
            dayAmount[transaction.date, default: 0] += transaction.type == .income ? transaction.money : -transaction.money
            print("✅ Date: \(transaction.date), Amount: \(dayAmount[transaction.date])")
        }
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

    func getCellDate(index: Int) -> Date? {
        if index < curFirstWeekday { return nil }
        let (year, month) = getYearAndMonth()
        let dateComponents = DateComponents(year: year, month: month, day: index - curFirstWeekday + 1)
        return Calendar.current.date(from: dateComponents)
    }
}
