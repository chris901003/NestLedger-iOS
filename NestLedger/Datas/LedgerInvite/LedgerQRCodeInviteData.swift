// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerQRCodeInviteData: Codable {
    let token: String
    let createAt: Date
    let expiresAt: Date
    let link: String
}

typealias LedgerQRCodeInviteDataResponse = APIResponseData<LedgerQRCodeInviteData>
