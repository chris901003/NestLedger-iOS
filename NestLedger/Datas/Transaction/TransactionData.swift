// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum TransactionType: String, Codable {
    case income = "income"
    case expenditure = "expenditure"
}

struct TransactionData: Codable {
    var _id: String = ""
    var title: String
    var note: String
    var money: Int
    var date: Date
    var type: TransactionType
    var userId: String
    var tagId: String
    var ledgerId: String
    var version: Int = TRANSACTION_DATA_VERSION

    static func initEmpty() -> TransactionData {
        .init(
            _id: "",
            title: "",
            note: "",
            money: 0,
            date: Date.now,
            type: .income,
            userId: "",
            tagId: "",
            ledgerId: "",
            version: TRANSACTION_DATA_VERSION
        )
    }

    func isValid() -> String? {
        guard money > 0 else { return "金額不可為 0" }
        guard !tagId.isEmpty else { return "請選擇標籤" }
        return nil
    }
}

struct TransactionDataWrapper: Codable {
    let transaction: TransactionData
}

struct TransactionsDataWrapper: Codable {
    let transactions: [TransactionData]
}

typealias TransactionResponse = APIResponseData<TransactionDataWrapper>
typealias TransactionsResponse = APIResponseData<TransactionsDataWrapper>
typealias CleanTransactionResponse = APIResponseData<TransactionData>
typealias CleanTransactionsResponse = APIResponseData<[TransactionData]>
