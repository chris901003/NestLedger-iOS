// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerSplitUserInviteData: Codable {
    let id: String
    let ledgerSplitId: String
    let sendUserId: String
    let receiveUserId: String
    let expireAt: Date
}

typealias LedgerSplitUserInviteDataResponse = APIResponseData<LedgerSplitUserInviteData>
typealias LedgerSplitUserInviteDatasResponse = APIResponseData<[LedgerSplitUserInviteData]>
