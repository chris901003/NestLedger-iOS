// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Combine

@MainActor
final class LSTransactionStore {
    @Published private(set) var amount: Int = 0

    var amountPublisher: AnyPublisher<Int, Never> {
        $amount
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func update(amount: Int? = nil) {
        if let amount {
            self.amount = amount
        }
    }

    func addAmount(_ value: Int) {
        self.amount += value
    }
}
