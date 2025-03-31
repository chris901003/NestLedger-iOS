// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class LTransactionManager {
    weak var vc: LTransactionView?

    var transactions: [TransactionData] = []

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectDayTransactions), name: .ledgerDetailSelectDayTransactions, object: nil)
    }

    @objc private func selectDayTransactions(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let transactions = userInfo["transactions"] as? [TransactionData] else { return }
        self.transactions = transactions
        DispatchQueue.main.async { [weak self] in
            self?.vc?.tableView.reloadData()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                vc?.tableViewHeightConstraint?.constant = min(400, vc?.tableView.contentSize.height ?? 8)
            }
        }
    }
}
