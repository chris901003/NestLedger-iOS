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

        transaction.userId = newSharedUserInfo.id
        transaction.ledgerId = ledgerId

        Task {
            do {
                let newTransaction = try await newApiManager.createTransaction(data: TransactionCreateRequestData(transaction))
                completion()
                await MainActor.run {
                    NotificationCenter.default.post(name: .newRecentTransaction, object: nil, userInfo: ["transaction": newTransaction])
                    vc?.totalValue = 0
                    vc?.tagView.reset()
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "添加成功")
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
                completion()
            }
        }
    }
}
