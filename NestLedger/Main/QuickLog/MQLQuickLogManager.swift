// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/6.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class MQLQuickLogManager {
    let newApiManager = NewAPIManager()

    var transaction = TransactionData.initEmpty()
    weak var vc: MQuickLogView?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSetMainLedger), name: .setMainLedger, object: nil)
    }

    @objc private func receiveSetMainLedger(_ notification: Notification) {
        vc?.tagView.reset()
    }
}

extension MQLQuickLogManager: MQLSendViewDelegate {
    func sendAction(completion: @escaping () -> Void) {
        guard let ledgerId = newSharedUserInfo.ledgerIds.first else {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "添加失敗，無法取得帳本")
            completion()
            return
        }
        guard !transaction.tagId.isEmpty else {
            XOBottomBarInformationManager.showBottomInformation(type: .info, information: "請先選擇標籤")
            completion()
            return
        }
        guard transaction.money != 0 else {
            XOBottomBarInformationManager.showBottomInformation(type: .info, information: "金額不可為 0")
            completion()
            return
        }

        transaction.date = Date.now
        transaction.userId = newSharedUserInfo.id
        transaction.ledgerId = ledgerId

        Task {
            do {
                let newTransaction = try await newApiManager.createTransaction(data: TransactionCreateRequestData(transaction))
                completion()
                await MainActor.run {
                    NLNotification.sendNewRecentTransaction(newTransaction: newTransaction)
                    vc?.totalValue = 0
                    vc?.tagView.reset()
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "添加成功")
                }
            } catch NewAPIManager.NewAPIManagerError.unauthorizedError(_) {
                NLNotification.sendUnauthorizedLedger(ledgerId: ledgerId)
                transaction.tagId = ""
                await MainActor.run { vc?.tagView.reset() }
                completion()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
                completion()
            }
        }
    }
}
