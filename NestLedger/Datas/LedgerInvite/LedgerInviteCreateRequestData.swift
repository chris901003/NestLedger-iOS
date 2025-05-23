// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerInviteCreateRequestData: Encodable {
    let ledgerId: String
    let sendUserId: String
    let receiveUserId: String
    let version: Int = LEDGER_DATA_VERSION
}
