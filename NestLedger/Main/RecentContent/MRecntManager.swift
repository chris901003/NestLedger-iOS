// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class MRecntManager {
    let apiManager = APIManager()

    var ledgerId: String
    var recentTransactions: [TransactionData] = []

    init() {
        ledgerId = sharedUserInfo.ledgerIds.first ?? ""

        let searchConfig = APIManager.TransactionGetByLedgerQuery(
            ledgerId: ledgerId,
            page: 1,
            limit: 10,
            search: nil,
            startDate: nil,
            endDate: nil,
            tagId: nil,
            type: nil,
            userId: nil,
            sortedOrder: .descending
        )

        

        Task {
            do {
                recentTransactions = try await apiManager.getTransactionByLedger(config: searchConfig)
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取得近期帳目")
            }
        }
    }
}
