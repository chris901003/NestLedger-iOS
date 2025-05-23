// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerUpdateRequestData: Encodable {
    let _id: String
    let title: String?
    let version: Int?

    init(_ data: LedgerData) {
        _id = data._id
        title = data.title
        version = data.version
    }
}
