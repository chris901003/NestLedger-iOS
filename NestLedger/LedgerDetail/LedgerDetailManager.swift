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
