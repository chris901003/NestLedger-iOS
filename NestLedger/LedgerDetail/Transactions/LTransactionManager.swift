// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LTransactionManager {
    weak var vc: LTransactionView?

    let apiManager = APIManager()

    var transactions: [TransactionData] = []
    var userAvatars: [String: UIImage] = [:]

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectDayTransactions), name: .ledgerDetailSelectDayTransactions, object: nil)
    }

    @objc private func selectDayTransactions(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let transactions = userInfo["transactions"] as? [TransactionData] else { return }
        self.transactions = transactions
        Task {
            try? await fetchUserAvatar()
            DispatchQueue.main.async { [weak self] in
                self?.vc?.tableView.reloadData()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    vc?.tableViewHeightConstraint?.constant = min(400, vc?.tableView.contentSize.height ?? 8)
                }
            }
        }
    }

    private func fetchUserAvatar() async throws {
        let uniqueUserIds = Array(Set(transactions.map({ $0.userId })))
        try await withThrowingTaskGroup(of: (String, UIImage)?.self) { group in
            for userId in uniqueUserIds {
                group.addTask { [weak self] in
                    guard let self else { return nil }
                    let avatar = try await apiManager.getUserAvatar(userId: userId)
                    return (userId, avatar)
                }
            }
            for try await data in group {
                guard let data else { continue }
                userAvatars[data.0] = data.1
            }
        }
    }
}
