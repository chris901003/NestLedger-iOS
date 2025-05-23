// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

protocol TransactionManagerDelegate: AnyObject {
    func updateTagInformation(tag: TagData)
}

class TransactionManager {
    let newApiManager = NewAPIManager()
    let oldTransactionData: TransactionData?
    var transactionData: TransactionData
    var tagData: TagData = TagData.initEmpty()

    weak var delegate: TransactionManagerDelegate?

    init(transactionData: TransactionData?, initialDate: Date? = nil) {
        self.oldTransactionData = transactionData ?? nil
        self.transactionData = transactionData ?? TransactionData.initEmpty()
        if let initialDate { self.transactionData.date = initialDate }
        Task {
            do {
                if !self.transactionData.tagId.isEmpty {
                    tagData = try await getTagInformation()
                    await MainActor.run {
                        delegate?.updateTagInformation(tag: tagData)
                    }
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取標籤資訊失敗")
            }
        }
    }

    private func getTagInformation() async throws -> TagData {
        try await newApiManager.getTag(tagId: transactionData.tagId)
    }

    func saveTransasction() async -> String? {
        if let oldTransactionData {
            do {
                transactionData = try await newApiManager.updateTransaction(data: .init(transactionData))
                NLNotification.sendUpdateTransaction(oldTransaction: oldTransactionData, newTransaction: transactionData)
                return nil
            } catch {
                return "更新帳目失敗"
            }
        } else {
            if let message = transactionData.isValid() {
                return message
            }
            do {
                transactionData.userId = newSharedUserInfo.id
                let newTransaction = try await newApiManager.createTransaction(data: .init(transactionData))
                await MainActor.run {
                    NLNotification.sendNewRecentTransaction(newTransaction: newTransaction)
                }
            } catch {
                return "創建帳目失敗"
            }
            return nil
        }
    }
}

// MARK: - XOTitleWithUnderlineInputDelegate
extension TransactionManager: XOTitleWithUnderlineInputDelegate {
    func inputWithUnderline(vc: XOTitleWithUnderlineInputView, text: String) {
        transactionData.title = text
    }
}

// MARK: - TDateSelectionViewDelegate
extension TransactionManager: TDateSelectionViewDelegate {
    func changeDate(newDate: Date) {
        transactionData.date = newDate
    }
}

// MARK: - TIncomeExpenseSelectorViewDelegate
extension TransactionManager: TIncomeExpenseSelectorViewDelegate {
    func changeType(type: TransactionType) {
        transactionData.type = type
    }
}

// MARK: - TAmountViewDelegate
extension TransactionManager: TAmountViewDelegate {
    func updateAmount(amount: Int) {
        transactionData.money = amount
    }
}
