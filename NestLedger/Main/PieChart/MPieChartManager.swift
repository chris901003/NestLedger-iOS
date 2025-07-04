// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/18.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI
import UIKit

extension MPieChartManager {
    struct MPieChartData {
        let tagLabel: String
        let tagColor: UIColor
        let tagAmount: Int
        let percent: Int
    }
}

class MPieChartManager {
    var ledgerId: String
    var year: Int
    var month: Int

    let type: MPieChartView.PieChartType
    let newApiManager = NewAPIManager()
    var pieChartData: [MPieChartData] = []

    weak var vc: MPieChartView?

    init(type: MPieChartView.PieChartType) {
        self.type = type
        ledgerId = newSharedUserInfo.ledgerIds.first ?? ""
        year = Calendar.current.component(.year, from: Date.now)
        month = Calendar.current.component(.month, from: Date.now)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadLedgerInfo), name: .newRecentTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLedgerInfo), name: .updateTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLedgerInfo), name: .deleteTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSetMainLedger), name: .setMainLedger, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLedgerInfo), name: .refreshMainView, object: nil)

        Task {
            do {
                try await loadLedgerInfo()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳本資訊失敗")
            }
        }
    }

    @objc private func reloadLedgerInfo() {
        ledgerId = newSharedUserInfo.ledgerIds.first ?? ""
        Task { try? await loadLedgerInfo() }
    }

    func loadLedgerInfo() async throws {
        pieChartData = []
        try await getLedgerInformation()
        if pieChartData.isEmpty {
            pieChartData.append(.init(tagLabel: "無", tagColor: .systemGray5, tagAmount: 1, percent: 100))
        }
        await MainActor.run {
            let chartData = pieChartData.map { data in
                (CGFloat(data.tagAmount), data.tagColor)
            }
            vc?.pieChartView.data = chartData
            vc?.tableView.reloadData()
        }
    }

    private func getLedgerInformation() async throws {
        let startComponent = DateComponents(year: year, month: month, day: 1)
        guard let startDate = Calendar.current.date(from: startComponent),
              let endDate = Calendar.current.date(byAdding: DateComponents(month: 1, second: -1), to: startDate) else { return }
        
        let queryConfig = TransactionQueryRequestData(
            ledgerId: ledgerId,
            startDate: startDate,
            endDate: endDate,
            type: type == .income ? .income : .expenditure
        )
        let transactions = try await newApiManager.queryTransaction(data: queryConfig)
        var totalAmount = 0
        var tagAmount: [String: Int] = [:]
        for transaction in transactions {
            tagAmount[transaction.tagId] = tagAmount[transaction.tagId, default: 0] + transaction.money
            totalAmount += transaction.money
        }
        var remainAmount = totalAmount
        let sortedTagAmount = tagAmount.sorted { $0.value > $1.value }
        let topKTags = sortedTagAmount.prefix(min(4, sortedTagAmount.count))
        for topTag in topKTags {
            let tagData = try await newApiManager.getTag(tagId: topTag.key)
            pieChartData.append(.init(tagLabel: tagData.label, tagColor: tagData.getColor, tagAmount: topTag.value, percent: Int(Float(topTag.value) / Float(totalAmount) * 100)))
            remainAmount -= topTag.value
        }
        if remainAmount > 0 {
            pieChartData.append(.init(tagLabel: "其他", tagColor: UIColor.systemGray5, tagAmount: remainAmount, percent: Int(Float(remainAmount) / Float(totalAmount) * 100)))
        }
    }
}

extension MPieChartManager {
    @objc private func receiveSetMainLedger(_ notification: Notification) {
        guard let mainLedgerId = NLNotification.decodeSetMainLedger(notification),
              mainLedgerId != ledgerId else { return }
        ledgerId = mainLedgerId
        reloadLedgerInfo()
    }
}
