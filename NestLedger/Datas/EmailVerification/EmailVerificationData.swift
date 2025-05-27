// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/27.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct EmailVerificationData: Codable {
    let uid: String
    let emailAddress: String
    let expireAt: Date
}

typealias EmailVerificationResponse = APIResponseData<EmailVerificationData?>
