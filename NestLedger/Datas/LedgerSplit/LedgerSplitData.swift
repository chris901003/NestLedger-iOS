// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerSplitData: Codable {
    let _id: String
    var title: String
    var userIds: [String]
    var totalIncome: Int
    var totalExpense: Int
    var userNames: [String: String]
    var records: [String: [String: Int]]
    var version: Int = LEDGER_SPLIT_DATA_VERSION

    static func initMock() -> LedgerSplitData {
        .init(_id: "", title: "", userIds: [], totalIncome: 0, totalExpense: 0, userNames: [:], records: [:])
    }
}

typealias CleanLedgerSplitDataResponse = APIResponseData<LedgerSplitData>
