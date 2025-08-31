// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct UserFeedbackRequestData: Codable {
    let title: String
    let content: String
    let emailAddress: String

    func isValid() -> Bool {
        !title.isEmpty && !content.isEmpty
    }
}
