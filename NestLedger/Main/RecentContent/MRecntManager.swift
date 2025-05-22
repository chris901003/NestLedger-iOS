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
    let newApiManager = NewAPIManager()

    var ledgerId: String
    var recentTransactions: [TransactionData] = []

    weak var vc: MRecentContentView?

    init() {
        ledgerId = newSharedUserInfo.ledgerIds.first ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTransaction), name: .updateTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDeleteTransaction), name: .deleteTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSetMainLedger), name: .setMainLedger, object: nil)
        loadRecentTransaction()
    }

    private func loadRecentTransaction() {
        let searchConfig = TransactionQueryRequestData(
            ledgerId: ledgerId,
            search: nil,
            startDate: nil,
            endDate: nil,
            tagId: nil,
            type: nil,
            userId: nil,
            sortOrder: .descending,
            page: 1,
            limit: 10
        )

        Task {
            do {
                recentTransactions = try await newApiManager.queryTransaction(data: searchConfig)
                await MainActor.run { vc?.tableView.reloadData() }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取得近期帳目")
            }
        }
    }

    @objc private func receiveNewTransaction(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let transaction = userInfo["transaction"] as? TransactionData,
              transaction.ledgerId == ledgerId else { return }
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

    @objc private func receiveDeleteTransaction(_ notification: Notification) {
        guard let deleteTransaction = NLNotification.decodeDeleteTransaction(notification) else { return }
        guard let idx = recentTransactions.firstIndex(where: { $0._id == deleteTransaction._id }) else { return }
        recentTransactions.remove(at: idx)
        DispatchQueue.main.async { [weak self] in
            self?.vc?.tableView.reloadData()
        }
    }

    @objc private func receiveSetMainLedger(_ notification: Notification) {
        guard let mainLedgerId = NLNotification.decodeSetMainLedger(notification),
              mainLedgerId != ledgerId else { return }
        ledgerId = mainLedgerId
        loadRecentTransaction()
    }
}
