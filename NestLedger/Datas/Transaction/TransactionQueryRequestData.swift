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
    var page: Int?
    let limit: Int?

    init(ledgerId: String,
         search: String? = nil,
         startDate: Date? = nil,
         endDate: Date? = nil,
         tagId: String? = nil,
         type: TransactionType? = nil,
         userId: String? = nil,
         sortOrder: TransactionQuerySortOrder? = nil,
         page: Int? = nil,
         limit: Int? = nil
    ) {
        self.ledgerId = ledgerId
        self.search = search
        self.startDate = startDate
        self.endDate = endDate
        self.tagId = tagId
        self.type = type
        self.userId = userId
        self.sortOrder = sortOrder
        self.page = page
        self.limit = limit
    }
}
