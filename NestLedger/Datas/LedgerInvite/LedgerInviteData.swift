// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerInviteData: Codable {
    var _id: String = ""
    var ledgerId: String
    var sendUserId: String
    var receiveUserId: String
    var version: Int = LEDGER_INVITE_DATA_VERSION

    static func initEmpty() -> LedgerInviteData {
        .init(ledgerId: "", sendUserId: "", receiveUserId: "", version: LEDGER_INVITE_DATA_VERSION)
    }
}

struct LedgerInviteDataWrapper: Codable {
    let ledgerInvite: LedgerInviteData
}

struct LedgerInvitesDataWrapper: Codable {
    let ledgerInvites: [LedgerInviteData]
}

typealias LedgerInviteResponse = APIResponseData<LedgerInviteDataWrapper>
typealias LedgerInvitesResponse = APIResponseData<LedgerInvitesDataWrapper>
typealias CleanLedgerInvitesResponse = APIResponseData<[LedgerInviteData]>
