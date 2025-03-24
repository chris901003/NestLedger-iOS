// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class LedgerDetailManager {
    var ledgerData: LedgerData
    var ledgerTitle: String {
        get { ledgerData.title == "[Main]:\(sharedUserInfo.id)" ? "我的帳本" : ledgerData.title }
    }

    init(ledgerData: LedgerData) {
        self.ledgerData = ledgerData
    }
}
