// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSTSplitUserListViewController: UIViewController {
    let newAPIManager = NewAPIManager()

    let ledgerSplitData: LedgerSplitData
    let transactionStore: LSTransactionStore
    var userList: [String] = []

    let titleLabel = UILabel()
    let tableView = UITableView()

    init(ledgerSplitData: LedgerSplitData, transactionStore: LSTransactionStore) {
        self.ledgerSplitData = ledgerSplitData
        self.transactionStore = transactionStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserList()
        setup()
        layout()
        registerCell()
    }

    private func setup() {
        view.backgroundColor = .white

        titleLabel.text = "添加分帳人"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }

    private func registerCell() {
        tableView.register(LSTSplitUserListCell.self, forCellReuseIdentifier: LSTSplitUserListCell.cellId)
    }
}

// MARK: - Utility
extension LSTSplitUserListViewController {
    private func fetchUserList() {
        userList = ledgerSplitData.userIds.filter { userId in
            !(transactionStore.splitUsers.contains { $0.userId == userId })
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LSTSplitUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LSTSplitUserListCell.cellId, for: indexPath) as? LSTSplitUserListCell else {
            return UITableViewCell()
        }
        cell.config(userId: userList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - LSTSplitUserListCellDelegate
extension LSTSplitUserListViewController: LSTSplitUserListCellDelegate {
    func userJoin(_ cell: LSTSplitUserListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let id = userList[indexPath.row]
        userList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        transactionStore.addSplitUser(id: id)
    }
}
