// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct TagQueryRequestData: Encodable {
    let ledgerId: String
    let search: String?
    let tagId: String?
    var page: Int?
    let limit: Int?
}
