// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension Notification.Name {
    static let newRecentTransaction = Notification.Name("NewRecentTransaction")
    static let ledgerDetailSelectDayTransactions = Notification.Name("LedgerDetailSelectDayTransactions")
    static let ledgerDetailSelectDay = Notification.Name("LedgerDetailSelectDay")
    static let updateTransaction = Notification.Name("UpdateTransaction")
    static let deleteTransaction = Notification.Name("DeleteTransaction")
    static let updateLedger = Notification.Name("UpdateLedger")
    static let quitLedger = Notification.Name("QuitLedger")
    static let setMainLedger = Notification.Name("SetMainLedger")
    static let updateTag = Notification.Name("UpdateTag")
    static let refreshMainView = Notification.Name("RefreshMainView")
    static let refreshLedgerDetailView = Notification.Name("RefreshLedgerDetailView")
    static let refreshLedgerListView = Notification.Name("RefreshLedgerListView")
    static let unauthorizedLedger = Notification.Name("UnauthorizedLedger")
    static let statisticsNewData = Notification.Name("StatisticsNewData")
    static let statisticsLoadError = Notification.Name("StatisticsLoadError")
    static let newLedgerSplit = Notification.Name("NewLedgerSplit")
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

    // MARK: - Ledger Detail Select Day Transactions
    static func sendLedgerDetailSelectDayTransactions(dayTransactions: [TransactionData]) {
        NotificationCenter.default.post(name: .ledgerDetailSelectDayTransactions, object: nil, userInfo: ["transactions": dayTransactions])
    }

    static func decodeLedgerDetailSelectDayTransactions(_ notification: Notification) -> [TransactionData]? {
        guard let userInfo = notification.userInfo,
              let transactions = userInfo["transactions"] as? [TransactionData] else { return nil }
        return transactions
    }

    // MARK: - Ledger Detail Select Day
    static func sendLedgerDetailSelectDay(date: Date) {
        NotificationCenter.default.post(name: .ledgerDetailSelectDay, object: nil, userInfo: ["selectedDay": date])
    }

    static func decodeLedgerDetailSelectDay(_ notification: Notification) -> Date? {
        guard let userInfo = notification.userInfo,
              let selectedDay = userInfo["selectedDay"] as? Date else { return nil }
        return selectedDay
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

    // MARK: - Update Ledger
    static func sendUpdateLedger(ledgerData: LedgerData) {
        NotificationCenter.default.post(name: .updateLedger, object: nil, userInfo: ["ledgerData": ledgerData])
    }

    static func decodeUpdateLedger(_ notification: Notification) -> LedgerData? {
        guard let userInfo = notification.userInfo,
              let ledgerData = userInfo["ledgerData"] as? LedgerData else { return nil }
        return ledgerData
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

    // MARK: - Set Main Ledger
    static func sendSetMainLedger(ledgerId: String) {
        NotificationCenter.default.post(name: .setMainLedger, object: nil, userInfo: ["ledgerId": ledgerId])
    }

    static func decodeSetMainLedger(_ notification: Notification) -> String? {
        guard let userInfo = notification.userInfo,
              let ledgerId = userInfo["ledgerId"] as? String else { return nil }
        return ledgerId
    }

    // MARK: - Update Tag
    static func sendUpdateTag(tagData: TagData) {
        NotificationCenter.default.post(name: .updateTag, object: nil, userInfo: ["tagData": tagData])
    }

    static func decodeUpdateTag(_ notification: Notification) -> TagData? {
        guard let userInfo = notification.userInfo,
              let tagData = userInfo["tagData"] as? TagData else { return nil }
        return tagData
    }

    // MARK: - Refresh Main View
    static func sendRefreshMainView(ledgerId: String) {
        NotificationCenter.default.post(name: .refreshMainView, object: nil, userInfo: ["ledgerId": ledgerId])
    }

    static func decodeRefreshMainView(_ notification: Notification) -> String? {
        guard let userInfo = notification.userInfo,
              let ledgerId = userInfo["ledgerId"] as? String else { return nil }
        return ledgerId
    }

    // MARK: - Refresh Ledger Detail
    static func sendRefreshLedgerDetail(ledgerId: String) {
        NotificationCenter.default.post(name: .refreshLedgerDetailView, object: nil, userInfo: ["ledgerId": ledgerId])
    }

    static func decodeRefreshLedgerDetail(_ notificatino: Notification) -> String? {
        guard let userInfo = notificatino.userInfo,
              let ledgerId = userInfo["ledgerId"] as? String else { return nil }
        return ledgerId
    }

    // MARK: - Refresh Ledger List
    static func sendRefreshLedgerList() {
        NotificationCenter.default.post(name: .refreshLedgerListView, object: nil, userInfo: nil)
    }

    // MARK: - Unauthorized Ledger
    static func sendUnauthorizedLedger(ledgerId: String) {
        NotificationCenter.default.post(name: .unauthorizedLedger, object: nil, userInfo: ["ledgerId": ledgerId])
    }

    static func decodeUnauthorizedLedger(_ notification: Notification) -> String? {
        guard let userInfo = notification.userInfo,
              let ledgerId = userInfo["ledgerId"] as? String else { return nil }
        return ledgerId
    }

    // MARK: - Statistics New Data
    static func sendStatisticsNewData(for type: LDStatisticsManager.LoadType, transactionDatas: [TransactionData]) {
        NotificationCenter.default.post(name: .statisticsNewData, object: nil, userInfo: ["transactions": transactionDatas, "type": type])
    }

    static func decodeStatisticsNewData(_ notification: Notification, target: LDStatisticsManager.LoadType) -> [TransactionData]? {
        guard let userInfo = notification.userInfo,
              let transactionDatas = userInfo["transactions"] as? [TransactionData],
              let type = userInfo["type"] as? LDStatisticsManager.LoadType else { return nil }
        guard type == target else { return nil }
        return transactionDatas
    }

    // MARK: - Statistics Load Error
    static func sendStatisticsLoadError(for type: LDStatisticsManager.LoadType) {
        NotificationCenter.default.post(name: .statisticsLoadError, object: nil, userInfo: ["type": type])
    }

    static func decodeStatisticsLoadError(_ notification: Notification) -> LDStatisticsManager.LoadType? {
        guard let userInfo = notification.userInfo,
              let type = userInfo["type"] as? LDStatisticsManager.LoadType else { return nil }
        return type
    }

    // MARK: - New Ledger Split
    static func sendNewLedgerSplit(ledgerSplitData: LedgerSplitData, avatar: UIImage?) {
        NotificationCenter.default.post(
            name: .newLedgerSplit,
            object: nil,
            userInfo: ["ledgerSplitData": ledgerSplitData, "avatar": avatar as Any]
        )
    }

    static func decodeNewLedgerSplit(_ notificaion: Notification) -> (data: LedgerSplitData, avatar: UIImage?)? {
        guard let userInfo = notificaion.userInfo,
              let data = userInfo["ledgerSplitData"] as? LedgerSplitData else { return nil }
        let avatar = userInfo["avatar"] as? UIImage
        return (data, avatar)
    }
}
