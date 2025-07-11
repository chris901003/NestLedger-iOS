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
    let newApiManager = NewAPIManager()
    weak var vc: LedgerDetailViewController?

    var ledgerData: LedgerData {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let totalAmount = ledgerData.totalIncome - ledgerData.totalExpense
                vc?.totalLabel.text = "結餘: \(totalAmount)"
                vc?.totalLabel.textColor = totalAmount > 0 ? UIColor(hexCode: "#B1DD8B") : UIColor(hexCode: "#FF8484")
            }
        }
    }
    var ledgerTitle: String {
        get { ledgerData.title == "[Main]:\(newSharedUserInfo.id)" ? "我的帳本" : ledgerData.title }
    }
    var userInfos: [UserInfoData] = []
    var selectedDate: Date = Date.now

    init(ledgerData: LedgerData) {
        self.ledgerData = ledgerData
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTransaction), name: .updateTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDeleteTransaction), name: .deleteTransaction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateLedger), name: .updateLedger, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLedgerDetailSelectDay), name: .ledgerDetailSelectDay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUnauthorizedLedgerNotification), name: .unauthorizedLedger, object: nil)
        loadData()
    }

    private func getLedgerData() async throws {
        ledgerData = try await newApiManager.getLedger(ledgerId: ledgerData._id)
    }

    private func getUsers() async throws {
        let userInfos = try await newApiManager.getMultipleUserInfo(uids: ledgerData.userIds)
        self.userInfos = userInfos
    }

    private func loadData() {
        Task {
            do {
                try await getLedgerData()
                try await getUsers()
            } catch NewAPIManager.NewAPIManagerError.unauthorizedError(_) {
                await MainActor.run { NLNotification.sendUnauthorizedLedger(ledgerId: ledgerData._id) }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳本使用者敗")
            }
            await MainActor.run {
                vc?.avatarListView.reloadData()
                vc?.incomeExpenseView.config(income: self.ledgerData.totalIncome, expense: self.ledgerData.totalExpense)
            }
        }
    }

    func getUserAvatar(userData: UserInfoData) async -> UIImage? {
        if userData.isDelete {
            return UIImage.getDeleteUserAvatar()
        } else {
            return try? await newApiManager.getUserAvatar(uid: userData.id)
        }
    }

    func refreshData() {
        loadData()
        NLNotification.sendRefreshLedgerDetail(ledgerId: ledgerData._id)
        NLNotification.sendRefreshUserAvatarCache(uids: ledgerData.userIds)
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

    @objc private func receiveUpdateLedger(_ notification: Notification) {
        guard let newLedgerData = NLNotification.decodeUpdateLedger(notification),
              newLedgerData._id == ledgerData._id else { return }
        ledgerData = newLedgerData
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            vc?.titleLabel.text = ledgerData.title
            vc?.titleLabel.sizeToFit()
            vc?.incomeExpenseView.config(income: ledgerData.totalIncome, expense: ledgerData.totalExpense)
        }
    }

    @objc private func receiveLedgerDetailSelectDay(_ notification: Notification) {
        guard let selectedDay = NLNotification.decodeLedgerDetailSelectDay(notification) else { return }
        self.selectedDate = selectedDay
    }

    @objc private func receiveUnauthorizedLedgerNotification(_ notification: Notification) {
        guard let unauthorizedLedgerId = NLNotification.decodeUnauthorizedLedger(notification),
              unauthorizedLedgerId == ledgerData._id else { return }
        vc?.navigationController?.popViewController(animated: true)
    }
}
