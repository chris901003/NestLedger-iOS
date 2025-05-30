// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerData: Codable {
    var _id: String
    var title: String
    var userIds: [String]
    var totalIncome: Int
    var totalExpense: Int
    var version: Int = LEDGER_DATA_VERSION

    static func initMock() -> LedgerData {
        .init(_id: "", title: "", userIds: [], totalIncome: 0, totalExpense: 0)
    }

    var titleShow: String {
        get { title.starts(with: "[Main]") ? "我的帳本" : title }
    }
}

struct LedgerDataWrapper: Codable {
    let Ledger: LedgerData
}

typealias LedgerDataResponse = APIResponseData<LedgerDataWrapper>
typealias CleanLedgerDataResponse = APIResponseData<LedgerData>
typealias OptionalLedgerDataResponse = APIResponseData<LedgerData?>
