// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class MCalendarManager {
    weak var vc: MCalendarView?
    var calendarDay = Date.now {
        didSet {
            updateFirstWeekday()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                vc?.collectionView.reloadData()
                vc?.yearMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: calendarDay)
            }
            updateTransaction()
        }
    }
    var selectedDay = Date.now
    var curFirstWeekday: Int = 0
    var dayAmount: [String: Int] = [:]
    var dayTransactions: [String: [TransactionData]] = [:]

    let ledgerId: String
    let apiManager = APIManager()
    let userTimeZone = TimeZone(secondsFromGMT: 60 * 60 * sharedUserInfo.timeZone)!
    let formatter = DateFormatter()

    init(ledgerId: String) {
        self.ledgerId = ledgerId
        formatter.timeZone = userTimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        updateFirstWeekday()
        updateTransaction()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
    }

    @objc private func receiveNewTransaction(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let transaction = userInfo["transaction"] as? TransactionData else { return }
        let dateString = formatter.string(from: transaction.date)
        dayTransactions[dateString, default: []].append(transaction)
        dayAmount[dateString, default: 0] += transaction.type == .income ? transaction.money : -transaction.money
        DispatchQueue.main.async { [weak self] in
            self?.vc?.collectionView.reloadData()
        }
    }

    func updateTransaction() {
        dayAmount = [:]
        dayTransactions = [:]
        Task {
            do {
                try await getTransactions()
                await MainActor.run {
                    vc?.collectionView.reloadData()
                    let dateString = formatter.string(from: selectedDay)
                    NotificationCenter.default.post(
                        name: .ledgerDetailSelectDayTransactions,
                        object: nil,
                        userInfo: ["transactions": dayTransactions[dateString, default: []]]
                    )
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳目失敗")
            }
        }
    }

    private func getTransactions() async throws {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: calendarDay)
        components.month = Calendar.current.component(.month, from: calendarDay)
        components.day = 1
        guard let startDate = Calendar.current.date(from: components) else { return }
        components.day = Calendar.current.range(of: .day, in: .month, for: startDate)?.count
        components.hour = 23
        components.minute = 59
        components.second = 59
        guard let endDate = Calendar.current.date(from: components) else { return }

        let transactions = try await apiManager.getTransactionByLedger(config: .init(
            ledgerId: ledgerId,
            startDate: startDate,
            endDate: endDate
        ))
        for transaction in transactions {
            let dateString = formatter.string(from: transaction.date)
            dayTransactions[dateString, default: []].append(transaction)
            dayAmount[dateString, default: 0] += transaction.type == .income ? transaction.money : -transaction.money
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
        let year = calendar.component(.year, from: calendarDay)
        let month = calendar.component(.month, from: calendarDay)
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
