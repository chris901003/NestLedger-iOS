// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSDetailView: UIView {
    let label = UILabel()
    let tableView = UITableView()

    let hintView = LDSDetailHintView()
    let errorView = LDSDetailErrorView()

    let apiManager = NewAPIManager()
    let dataType: LDStatisticsManager.LoadType
    var transactions: [String: [TransactionData]] = [:]
    var tagPercentage: [(tagId: String, percentage: Double)] = []

    init(type: LDStatisticsManager.LoadType) {
        self.dataType = type
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()

        NotificationCenter.default.addObserver(self, selector: #selector(receiveStatisticsNotification), name: .statisticsNewData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveStatisticsErrorNotification), name: .statisticsLoadError, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        errorView.alpha = 0

        label.text = "分析"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .left
        label.alpha = 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alpha = 0
    }

    private func layout() {
        addSubview(hintView)
        hintView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hintView.centerXAnchor.constraint(equalTo: centerXAnchor),
            hintView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(LDSDetailCell.self, forCellReuseIdentifier: LDSDetailCell.cellId)
    }
}

// MARK: - UITableViewDelegate
extension LDSDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tagPercentage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSDetailCell.cellId, for: indexPath) as? LDSDetailCell else {
            return UITableViewCell()
        }
        let data = tagPercentage[indexPath.row]
        if let tagData = CacheTagData.shared.getTagData(tagId: data.tagId) {
            cell.config(data: .init(color: tagData.getColor, title: tagData.label, percentage: data.percentage))
        } else {
            Task {
                guard let tagData = try? await apiManager.getTag(tagId: data.tagId) else { return }
                await MainActor.run {
                    CacheTagData.shared.updateTagData(tagData: tagData)
                    cell.config(data: .init(color: tagData.getColor, title: tagData.label, percentage: data.percentage))
                }
            }
        }
        return cell
    }
}

// MARK: - Notfication Center
extension LDSDetailView {
    @objc private func receiveStatisticsNotification(_ notification: Notification) {
        guard let transactionDatas = NLNotification.decodeStatisticsNewData(notification, target: dataType) else { return }
        if hintView.alpha == 1 {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                hintView.alpha = 0
                label.alpha = 1
                tableView.alpha = 1
            }
        }
        self.transactions = [:]
        self.tagPercentage = []
        var totalAmount = 0
        var tagPercentage: [String: Int] = [:]
        for transaction in transactionDatas {
            transactions[transaction.tagId, default: []].append(transaction)
            tagPercentage[transaction.tagId, default: 0] += transaction.money
            totalAmount += transaction.money
        }
        let sortedTagPercentage = tagPercentage.sorted { $1.value < $0.value }
        for (key, value) in sortedTagPercentage {
            self.tagPercentage.append((key, Double(value) / Double(totalAmount)))
        }
        tableView.reloadData()
    }

    @objc private func receiveStatisticsErrorNotification(_ notification: Notification) {
        guard let type = NLNotification.decodeStatisticsLoadError(notification),
              type == dataType else { return }
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            errorView.alpha = 1
            hintView.alpha = 0
        }
    }
}
