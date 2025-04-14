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
    let ledgerId: String
    var year: Int
    var month: Int

    let apiManager = APIManager()
    var pieChartData: [MPieChartData] = []

    weak var vc: MPieChartView?

    init() {
        ledgerId = sharedUserInfo.ledgerIds.first ?? ""
        year = Calendar.current.component(.year, from: Date.now)
        month = Calendar.current.component(.month, from: Date.now)

        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTransaction), name: .updateTransaction, object: nil)

        Task {
            do {
                try await loadLedgerInfo()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳本資訊失敗")
            }
        }
    }

    @objc private func receiveNewTransaction() {
        Task { try? await loadLedgerInfo() }
    }

    @objc private func receiveUpdateTransaction() {
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
        let transactions = try await apiManager.getTransactionByLedger(config: .init(ledgerId: ledgerId, startDate: startDate, endDate: endDate))
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
            let tagData = try await apiManager.getTag(tagId: topTag.key)
            pieChartData.append(.init(tagLabel: tagData.label, tagColor: tagData.getColor, tagAmount: topTag.value, percent: Int(Float(topTag.value) / Float(totalAmount) * 100)))
            remainAmount -= topTag.value
        }
        if remainAmount > 0 {
            pieChartData.append(.init(tagLabel: "其他", tagColor: UIColor.systemGray5, tagAmount: remainAmount, percent: Int(Float(remainAmount) / Float(totalAmount) * 100)))
        }
    }
}
