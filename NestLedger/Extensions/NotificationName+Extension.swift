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
    static let deleteTransaction = Notification.Name("DeleteTransaction")
    static let quitLedger = Notification.Name("QuitLedger")
}

class NLNotification {
    // MARK: - Send New Transaction
    static func sendNewRecentTransaction(newTransaction: TransactionData) {
        NotificationCenter.default.post(name: .newRecentTransaction, object: nil, userInfo: ["transaction": newTransaction])
    }

    static func decodeNewRecentTransaction(_ notification: Notification) -> TransactionData? {
        guard let userInfo = notification.userInfo,
              let transaction = userInfo["transaction"] as? TransactionData else { return nil }
        return transaction
    }

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

    // MARK: - Delete Transaction
    static func sendDeleteTransaction(deleteTransaction: TransactionData) {
        NotificationCenter.default.post(name: .deleteTransaction, object: nil, userInfo: ["transaction": deleteTransaction])
    }

    static func decodeDeleteTransaction(_ notification: Notification) -> TransactionData? {
        guard let userInfo = notification.userInfo,
              let deleteTransaction = userInfo["transaction"] as? TransactionData else { return nil }
        return deleteTransaction
    }

    // MARK: - Quit Ledger
    static func sendQuitLedger(ledgerId: String) {
        NotificationCenter.default.post(name: .quitLedger, object: nil, userInfo: ["ledgerId": ledgerId])
    }

    static func decodeQuitLedger(_ notification: Notification) -> String? {
        guard let userInfo = notification.userInfo,
              let ledgerId = userInfo["ledgerId"] as? String else { return nil }
        return ledgerId
    }
}
