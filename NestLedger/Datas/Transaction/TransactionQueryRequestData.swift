// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum TransactionQuerySortOrder: Int, Encodable {
    case ascending = -1
    case descending = 1
}

struct TransactionQueryRequestData: Encodable {
    let ledgerId: String
    let search: String?
    let startDate: Date?
    let endDate: Date?
    let tagId: String?
    let type: TransactionType?
    let userId: String?
    let sortOrder: TransactionQuerySortOrder?
    let page: Int?
    let limit: Int?
}
