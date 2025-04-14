// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class MRecntManager {
    let apiManager = APIManager()

    var ledgerId: String
    var recentTransactions: [TransactionData] = []

    weak var vc: MRecentContentView?

    init() {
        ledgerId = sharedUserInfo.ledgerIds.first ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTransaction), name: .updateTransaction, object: nil)
        loadRecentTransaction()
    }

    private func loadRecentTransaction() {
        let searchConfig = APIManager.TransactionGetByLedgerQuery(
            ledgerId: ledgerId,
            page: 1,
            limit: 10,
            search: nil,
            startDate: nil,
            endDate: nil,
            tagId: nil,
            type: nil,
            userId: nil,
            sortedOrder: .descending
        )

        Task {
            do {
                recentTransactions = try await apiManager.getTransactionByLedger(config: searchConfig)
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取得近期帳目")
            }
        }
    }

    @objc private func receiveNewTransaction(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let transaction = userInfo["transaction"] as? TransactionData else { return }
        recentTransactions.insert(transaction, at: 0)
        DispatchQueue.main.async { [weak self] in
            self?.vc?.tableView.reloadData()
        }
    }

    @objc private func receiveUpdateTransaction(_ notification: Notification) {
        guard let (oldTransaction, newTransaction) = NLNotification.decodeUpdateTransacton(notification) else { return }
        guard let idx = recentTransactions.firstIndex(where: { $0._id == oldTransaction._id }) else { return }
        recentTransactions[idx] = newTransaction
        DispatchQueue.main.async { [weak self] in
            self?.vc?.tableView.reloadData()
        }
    }
}
