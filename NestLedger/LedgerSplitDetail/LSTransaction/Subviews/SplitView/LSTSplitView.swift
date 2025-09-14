// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI
import Combine

class LSTSplitView: UIView {
    let titleLabel = UILabel()
    let addButton = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "plus")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    )
    let tableView = UITableView()

    var tableViewHeightConstraint: NSLayoutConstraint!
    var vc: LSTransactionViewController?

    let ledgerSplitData: LedgerSplitData
    let transactionStore: LSTransactionStore
    var cancellables = Set<AnyCancellable>()

    init(ledgerSplitData: LedgerSplitData, transactionStore: LSTransactionStore) {
        self.ledgerSplitData = ledgerSplitData
        self.transactionStore = transactionStore
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()
        subscribeSplitUserList()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableHeight()
    }

    private func setup() {
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1).cgColor
        layer.borderWidth = 1.5

        titleLabel.text = "添加分帳對象"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        addButton.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addButton.layer.cornerRadius = 8.0
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddButtonAction)))
        addButton.isUserInteractionEnabled = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }

    private func layout() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: addButton.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
    }

    private func registerCell() {
        tableView.register(LSTSplitCell.self, forCellReuseIdentifier: LSTSplitCell.cellId)
    }
}

// MARK: - Utility
extension LSTSplitView {
    @objc private func tapAddButtonAction() {
        let userListVC = LSTSplitUserListViewController(ledgerSplitData: ledgerSplitData, transactionStore: transactionStore)
        let _50DetentId = UISheetPresentationController.Detent.Identifier("50")
        let _50Detent = UISheetPresentationController.Detent.custom(identifier: _50DetentId) { context in
            UIScreen.main.bounds.height * 0.5
        }
        if let sheet = userListVC.sheetPresentationController {
            sheet.detents = [_50Detent]
        }
        vc?.present(userListVC, animated: true)
    }

    private func subscribeSplitUserList() {
        transactionStore.$splitUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateTableHeight()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate, UITableViewDelegate
extension LSTSplitView: UITableViewDelegate, UITableViewDataSource {
    private func updateTableHeight() {
        tableView.layoutIfNeeded()
        let newHeight = max(10, tableView.contentSize.height)
        guard newHeight != tableViewHeightConstraint.constant else { return }
        tableViewHeightConstraint.constant = newHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionStore.splitUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LSTSplitCell.cellId, for: indexPath) as? LSTSplitCell else {
            return UITableViewCell()
        }
        let data = transactionStore.splitUsers[indexPath.row]
        cell.config(userId: data.userId, amount: data.amount)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "刪除") { _, _ , completion in
            tableView.performBatchUpdates { [weak self] in
                guard let self else { return }
                transactionStore.removeSplitUser(idx: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } completion: { [weak self] _ in
                guard let self else { return }
                updateTableHeight()
                completion(true)
            }

        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - LSTSplitCellDelegate
extension LSTSplitView: LSTSplitCellDelegate {
    func updateSplitAmount(_ cell: LSTSplitCell, amount: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        transactionStore.setSplitAmount(idx: indexPath.row, amount: amount)
    }
}
