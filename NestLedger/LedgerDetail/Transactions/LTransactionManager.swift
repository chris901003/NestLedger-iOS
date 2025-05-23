// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LTransactionManager {
    weak var vc: LTransactionView?

    let newApiManager = NewAPIManager()

    var transactions: [TransactionData] = []
    var userAvatars: [String: UIImage] = [:]

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectDayTransactions), name: .ledgerDetailSelectDayTransactions, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTransaction), name: .updateTransaction, object: nil)
    }

    @objc private func selectDayTransactions(_ notification: Notification) {
        guard let transactions = NLNotification.decodeLedgerDetailSelectDayTransactions(notification) else { return }
        self.transactions = transactions
        Task {
            try? await fetchUserAvatar()
            DispatchQueue.main.async { [weak self] in
                self?.vc?.tableView.reloadData()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    vc?.tableViewHeightConstraint?.constant = min(400, vc?.tableView.contentSize.height ?? 8)
                }
            }
        }
    }

    private func fetchUserAvatar() async throws {
        let uniqueUserIds = Array(Set(transactions.map({ $0.userId })))
        try await withThrowingTaskGroup(of: (String, UIImage)?.self) { group in
            for userId in uniqueUserIds {
                group.addTask { [weak self] in
                    guard let self else { return nil }
                    let avatar = try await newApiManager.getUserAvatar(uid: userId)
                    return (userId, avatar)
                }
            }
            for try await data in group {
                guard let data else { continue }
                userAvatars[data.0] = data.1
            }
        }
    }
}

extension LTransactionManager {
    @objc private func receiveUpdateTransaction(_ notification: Notification) {
        guard let (oldTransaction, newTransaction) = NLNotification.decodeUpdateTransacton(notification) else { return }
        if let idx = (transactions.firstIndex { $0._id == oldTransaction._id }) {
            transactions.remove(at: idx)
        }
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 60 * 60 * sharedUserInfo.timeZone)!
        if calendar.isDate(oldTransaction.date, inSameDayAs: newTransaction.date) {
            transactions.append(newTransaction)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            vc?.tableView.reloadData()
        }
    }
}
