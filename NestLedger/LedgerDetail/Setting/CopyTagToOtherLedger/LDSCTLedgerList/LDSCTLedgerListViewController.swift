// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSCTLedgerListViewController: UIViewController {
    let topBarView = UIView()
    let titleLabel = UILabel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
    }

    private func setup() {
        view.backgroundColor = .white

        topBarView.backgroundColor = .systemGray4
        topBarView.layer.cornerRadius = 3.0

        titleLabel.text = "帳本列表"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }

    private func layout() {
        view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            topBarView.widthAnchor.constraint(equalToConstant: 45),
            topBarView.heightAnchor.constraint(equalToConstant: 6),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }

    private func registerCell() {
        tableView.register(LDSCTLedgerCell.self, forCellReuseIdentifier: LDSCTLedgerCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSCTLedgerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSCTLedgerCell.cellId, for: indexPath) as? LDSCTLedgerCell else {
            return UITableViewCell()
        }
        cell.config(ledgerTitle: "Just for test")
        return cell
    }
}
