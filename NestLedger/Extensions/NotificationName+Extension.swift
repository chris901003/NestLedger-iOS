// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension Notification.Name {
    static let newRecentTransaction = Notification.Name("NewRecentTransaction")
    static let ledgerDetailSelectDayTransactions = Notification.Name("LedgerDetailSelectDayTransactions")
    static let updateTransaction = Notification.Name("UpdateTransaction")
}

class NLNotification {
    // MARK: - Update Transaction
    static func sendUpdateTransaction(oldTransaction: TransactionData, newTransaction: TransactionData) {
        NotificationCenter.default.post(name: .updateTransaction, object: nil, userInfo: ["oldTransaction": oldTransaction, "newTransaction": newTransaction])
    }

    static func decodeUpdateTransacton(_ notification: Notification) -> (oldTransaction: TransactionData, newTransaction: TransactionData)? {
        guard let userInfo = notification.userInfo,
              let oldTransaction = userInfo["oldTransaction"] as? TransactionData,
              let newTransaction = userInfo["newTransaction"] as? TransactionData else { return nil }
        return (oldTransaction, newTransaction)
    }
}
