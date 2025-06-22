// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct TagCopyRequestData: Encodable {
    let tagIds: [String]
    let targetLedgerId: String
}
