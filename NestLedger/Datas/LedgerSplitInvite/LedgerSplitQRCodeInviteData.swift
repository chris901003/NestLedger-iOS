// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerSplitQRCodeInviteData: Codable {
    let token: String
    let createAt: Date
    let expireAt: Date
    let link: String
}

typealias LedgerSplitQRCodeInviteDataResponse = APIResponseData<LedgerSplitQRCodeInviteData>
