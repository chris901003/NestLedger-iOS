// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct LedgerData: Codable {
    var _id: String
    var title: String
    var userIds: [String]
    var totalIncome: Int
    var totalExpense: Int
    var version: Int = LEDGER_DATA_VERSION
    // Version 2
    var userNames: [String: String]

    static func initMock() -> LedgerData {
        .init(_id: "", title: "", userIds: [], totalIncome: 0, totalExpense: 0, userNames: [:])
    }

    var titleShow: String {
        get { title.starts(with: "[Main]") ? "我的帳本" : title }
    }

    init(_id: String, title: String, userIds: [String], totalIncome: Int, totalExpense: Int, userNames: [String: String]) {
        self._id = _id
        self.title = title
        self.userIds = userIds
        self.totalIncome = totalIncome
        self.totalExpense = totalExpense
        self.userNames = userNames
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        title = try container.decode(String.self, forKey: .title)
        userIds = try container.decode([String].self, forKey: .userIds)
        totalIncome = try container.decode(Int.self, forKey: .totalIncome)
        totalExpense = try container.decode(Int.self, forKey: .totalExpense)
        version = try container.decode(Int.self, forKey: .version)

        if version < 2 {
            userNames = [:]
        } else {
            userNames = try container.decode([String: String].self, forKey: .userNames)
        }
    }
}

struct LedgerDataWrapper: Codable {
    let Ledger: LedgerData
}

typealias LedgerDataResponse = APIResponseData<LedgerDataWrapper>
typealias CleanLedgerDataResponse = APIResponseData<LedgerData>
typealias OptionalLedgerDataResponse = APIResponseData<LedgerData?>
