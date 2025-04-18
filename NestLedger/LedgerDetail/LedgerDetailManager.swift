// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LedgerDetailManager {
    let apiManager = APIManager()
    weak var vc: LedgerDetailViewController?

    var ledgerData: LedgerData
    var ledgerTitle: String {
        get { ledgerData.title == "[Main]:\(sharedUserInfo.id)" ? "我的帳本" : ledgerData.title }
    }
    var userInfos: [UserInfoData] = []

    init(ledgerData: LedgerData) {
        self.ledgerData = ledgerData
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTransaction), name: .updateTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDeleteTransaction), name: .deleteTransaction, object: nil)
        Task {
            do {
                try await updateLedgerData()
                try await getUsers()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳本使用者敗")
            }
            await MainActor.run {
                vc?.avatarListView.reloadData()
                vc?.incomeExpenseView.config(income: self.ledgerData.totalIncome, expense: self.ledgerData.totalExpense)
            }
        }
    }

    private func updateLedgerData() async throws {
        ledgerData = try await apiManager.getLedger(ledgerId: ledgerData._id)
    }

    private func getUsers() async throws {
        let userInfos = try await apiManager.getMultipleUserInfo(userIds: ledgerData.userIds)
        self.userInfos = userInfos
    }

    func getUserAvatar(userId: String) async -> UIImage? {
        try? await apiManager.getUserAvatar(userId: userId)
    }
}

extension LedgerDetailManager {
    @objc private func receiveNewTransaction(_ notification: Notification) {
        guard let transaction = NLNotification.decodeNewRecentTransaction(notification) else { return }
        if transaction.type == .income {
            ledgerData.totalIncome += transaction.money
        } else if transaction.type == .expenditure {
            ledgerData.totalExpense += transaction.money
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            vc?.incomeExpenseView.config(income: ledgerData.totalIncome, expense: ledgerData.totalExpense)
        }
    }

    @objc private func receiveUpdateTransaction(_ notification: Notification) {
        guard let (oldTransaction, newTransaction) = NLNotification.decodeUpdateTransacton(notification) else { return }
        guard newTransaction.ledgerId == ledgerData._id else { return }
        if oldTransaction.type == .income {
            ledgerData.totalIncome -= oldTransaction.money
        } else {
            ledgerData.totalExpense -= oldTransaction.money
        }
        if newTransaction.type == .income {
            ledgerData.totalIncome += newTransaction.money
        } else {
            ledgerData.totalExpense += newTransaction.money
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            vc?.incomeExpenseView.config(income: ledgerData.totalIncome, expense: ledgerData.totalExpense)
        }
    }

    @objc private func receiveDeleteTransaction(_ notification: Notification) {
        guard let deleteTransaction = NLNotification.decodeDeleteTransaction(notification) else { return }
        guard deleteTransaction.ledgerId == ledgerData._id else { return }
        if deleteTransaction.type == .income {
            ledgerData.totalIncome -= deleteTransaction.money
        } else {
            ledgerData.totalExpense -= deleteTransaction.money
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            vc?.incomeExpenseView.config(income: ledgerData.totalIncome, expense: ledgerData.totalExpense)
        }
    }
}
