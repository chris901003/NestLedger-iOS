// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LTransactionView: UIView {
    let tableView = UITableView()

    var tableViewHeightConstraint: NSLayoutConstraint?

    let manager = LTransactionManager()
    weak var delegate: NLNeedPresent?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableViewHeightConstraint?.constant = min(400, tableView.contentSize.height)
    }

    private func setup() {
        manager.vc = self

        backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 10)
        tableViewHeightConstraint?.isActive = true
    }

    private func registerCell() {
        tableView.register(LTCell.self, forCellReuseIdentifier: LTCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LTransactionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LTCell.cellId, for: indexPath) as? LTCell else {
            return UITableViewCell()
        }
        let transaction = manager.transactions[indexPath.row]
        cell.config(transaction: transaction, avatar: manager.userAvatars[transaction.userId])
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = manager.transactions[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "編輯") { [weak self] action, view, completionHandler in
            guard let self else { return }
            let transactionVC = TransactionViewController(.init(transaction: data))
            delegate?.presentVC(transactionVC)
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { [weak self] action, view, completionHandler in
            guard let self else { return }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                completionHandler(true)
            }
            let removeAction = UIAlertAction(title: "刪除", style: .destructive) { _ in
                let newApiManager = NewAPIManager()
                Task {
                    do {
                        try await newApiManager.deleteTransaction(transactionId: data._id)
                        await MainActor.run { [weak self] in
                            guard let self else { return }
                            manager.transactions.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .left)
                            tableView.reloadData()
                            NLNotification.sendDeleteTransaction(deleteTransaction: data)
                            completionHandler(true)
                        }
                    } catch {
                        XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "刪除帳目失敗")
                    }
                }
            }
            let controller = UIAlertController(title: "刪除帳目", message: "確定要刪除帳目嗎?", preferredStyle: .alert)
            controller.addAction(cancelAction)
            controller.addAction(removeAction)
            delegate?.presentVC(controller)
        }

        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        80
    }
}
