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
    var title: String = ""
    var date: Date = .now
    @Published private(set) var amount: Int = 0
    var advancer: UserInfoData? = nil
    @Published private(set) var splitUsers: [(userId: String, amount: Int)] = []

    var amountPublisher: AnyPublisher<Int, Never> {
        $amount
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

// MARK: - Amount
extension LSTransactionStore {
    func update(amount: Int? = nil) {
        if let amount {
            self.amount = amount
        }
    }

    func addAmount(_ value: Int) {
        self.amount += value
    }
}

// MARK: - Split User
extension LSTransactionStore {
    func addSplitUser(id: String) {
        splitUsers.append((id, 0))
    }

    func removeSplitUser(idx: Int) {
        splitUsers.remove(at: idx)
    }

    func setSplitAmount(idx: Int, amount: Int) {
        splitUsers[idx].amount = amount
    }
}
