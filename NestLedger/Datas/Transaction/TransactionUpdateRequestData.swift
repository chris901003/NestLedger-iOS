// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct TransactionUpdateRequestData: Encodable {
    let _id: String
    let title: String?
    let note: String?
    let money: Int?
    let date: Date?
    let type: String?
    let tagId: String?
    let version: Int?

    init(_ data: TransactionData) {
        _id = data._id
        title = data.title.isEmpty ? nil : data.title
        note = data.note.isEmpty ? nil: data.note
        money = data.money
        date = data.date
        type = data.type.rawValue
        tagId = data.tagId
        version = data.version
    }
}
