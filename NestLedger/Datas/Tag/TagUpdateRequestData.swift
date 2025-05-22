// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct TagUpdateRequestData: Encodable {
    let _id: String
    let label: String?
    let color: String?
    let version: Int?

    init(_ data: TagData) {
        _id = data._id
        label = data.label
        color = data.color
        version = data.version
    }
}
