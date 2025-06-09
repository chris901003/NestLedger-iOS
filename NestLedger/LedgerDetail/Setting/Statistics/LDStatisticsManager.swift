// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

fileprivate class QueryWrapper {
    var incomeQueryData: TransactionQueryRequestData?
    var expenseQueryData: TransactionQueryRequestData?
    var totalQueryData: TransactionQueryRequestData?

    func setupQuery(_ queryData: TransactionQueryRequestData, type: LDStatisticsManager.LoadType) {
        switch type {
            case .income:
                incomeQueryData = queryData
            case .expense:
                expenseQueryData = queryData
            case .total:
                totalQueryData = queryData
        }
    }

    func getQuery(_ type: LDStatisticsManager.LoadType) -> TransactionQueryRequestData? {
        switch type {
            case .income:
                return incomeQueryData
            case .expense:
                return expenseQueryData
            case .total:
                return totalQueryData
        }
    }
}

class LDStatisticsManager {
    let ledgerId: String
    let apiManager = NewAPIManager()
    fileprivate let queryWrapper = QueryWrapper()
    var currentPage = 0 {
        willSet {
            guard newValue != currentPage,
                  let type = LoadType(rawValue: newValue) else { return }
            loadData(type: type)
        }
    }

    init(ledgerId: String) {
        self.ledgerId = ledgerId
    }

    func searchAction(startDate: Date, endDate: Date) {
        queryWrapper.setupQuery(.init(ledgerId: ledgerId, startDate: startDate, endDate: endDate, type: .income, sortOrder: .ascending), type: .income)
        queryWrapper.setupQuery(.init(ledgerId: ledgerId, startDate: startDate, endDate: endDate, type: .expenditure, sortOrder: .ascending), type: .expense)
        queryWrapper.setupQuery(.init(ledgerId: ledgerId, startDate: startDate, endDate: endDate, sortOrder: .ascending), type: .total)

        if let type = LoadType(rawValue: currentPage) { loadData(type: type) }
    }
}

// MARK: - Load Transaction Data
extension LDStatisticsManager {
    enum LoadType: Int {
        case income = 0, expense = 1, total = 2
    }

    func loadData(type: LoadType) {
        Task {
            guard let query = queryWrapper.getQuery(type) else { return }
            do {
                let transactions = try await apiManager.queryTransaction(data: query)
                await MainActor.run {
                    NLNotification.sendStatisticsNewData(for: type, transactionDatas: transactions)
                }
            } catch {
                // TODO: Send Notification And Show Load Failed Information
                print("✅ Error: \(error.localizedDescription)")
            }
        }
    }
}
