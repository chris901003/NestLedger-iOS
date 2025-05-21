// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct TagCreateRequestData: Encodable {
    let label: String
    let color: String
    let ledgerId: String
    let version: Int

    init(_ data: TagData) {
        label = data.label
        color = data.color
        ledgerId = data.ledgerId
        version = data.version
    }
}
