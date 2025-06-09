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

    init(ledgerId: String) {
        self.ledgerId = ledgerId
    }

    func searchAction(startDate: Date, endDate: Date) {
        queryWrapper.setupQuery(.init(ledgerId: ledgerId, startDate: startDate, endDate: endDate, type: .income, sortOrder: .ascending, page: 0, limit: 20), type: .income)
        queryWrapper.setupQuery(.init(ledgerId: ledgerId, startDate: startDate, endDate: endDate, type: .expenditure, sortOrder: .ascending, page: 0, limit: 20), type: .expense)
        queryWrapper.setupQuery(.init(ledgerId: ledgerId, startDate: startDate, endDate: endDate, sortOrder: .ascending, page: 0, limit: 20), type: .total)
    }
}

// MARK: - Load Transaction Data
extension LDStatisticsManager {
    enum LoadType {
        case income, expense, total
    }

    func loadMore(type: LoadType) async throws {
        guard var query = queryWrapper.getQuery(type) else { return }
        let transactions = try await apiManager.queryTransaction(data: query)
        query.page = (query.page ?? 0) + 1
        queryWrapper.setupQuery(query, type: type)
        NLNotification.sendStatisticsNewData(for: type, transactionDatas: transactions)
    }
}
