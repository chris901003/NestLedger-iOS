// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct TransactionCreateRequestData: Encodable {
    let title: String?
    let note: String?
    let money: Int
    let date: Date
    let type: TransactionType
    let userId: String
    let tagId: String
    let ledgerId: String
    let version: Int

    init(_ data: TransactionData) {
        title = data.title
        note = data.note
        money = data.money
        date = data.date
        type = data.type
        userId = data.userId
        tagId = data.tagId
        ledgerId = data.ledgerId
        version = data.version
    }
}
