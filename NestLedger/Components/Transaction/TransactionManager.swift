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
    let apiManager = APIManager()
    var transactionData: TransactionData
    var tagData: TagData = TagData.initEmpty()

    weak var delegate: TransactionManagerDelegate?

    init(transactionData: TransactionData?) {
        self.transactionData = transactionData ?? TransactionData.initEmpty()
        Task {
            do {
                tagData = try await getTagInformation()
                await MainActor.run {
                    delegate?.updateTagInformation(tag: tagData)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取標籤資訊失敗")
            }
        }
    }

    private func getTagInformation() async throws -> TagData {
        try await apiManager.getTag(tagId: transactionData.tagId)
    }

    func saveTransasction() async throws {
        try await apiManager.updateTransasction(data: transactionData)
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
