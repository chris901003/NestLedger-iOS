// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerCreateRequestData: Encodable {
    let title: String
    let userId: String
    let version: Int = LEDGER_DATA_VERSION
}
