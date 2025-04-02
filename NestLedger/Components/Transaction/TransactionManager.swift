// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class TransactionManager {
    var transactionData: TransactionData

    init(transactionData: TransactionData?) {
        self.transactionData = transactionData ?? TransactionData.initEmpty()
    }
}
