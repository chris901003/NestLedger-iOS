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
    var version: Int = LEDGER_DATA_VERSION
}

struct LedgerDataWrapper: Codable {
    let ledger: LedgerData
}

typealias LedgerDataResponse = APIResponseData<LedgerDataWrapper>
