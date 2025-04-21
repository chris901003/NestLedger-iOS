// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSLedgerMemberViewController: UIViewController {
    let manager: LDSLedgerMemberManager

    let addNewMemberView = LDSLMAddNewMemberView()
    let tableView = UITableView()

    init(ledgerId: String) {
        manager = LDSLedgerMemberManager(ledgerId: ledgerId)
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        manager.vc = self

        view.backgroundColor = .white
        navigationItem.title = "帳目成員"

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    private func layout() {
        view.addSubview(addNewMemberView)
        addNewMemberView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNewMemberView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addNewMemberView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addNewMemberView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addNewMemberView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(LDSLMCell.self, forCellReuseIdentifier: LDSLMCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSLedgerMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.userInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSLMCell.cellId, for: indexPath) as? LDSLMCell else { return UITableViewCell() }
        let data = manager.userInfos[indexPath.row]
        Task {
            let avatar = await manager.getUserAvatar(userId: data.id)
            await MainActor.run { cell.config(avatar: avatar, userName: data.userName) }
        }
        return cell
    }
}
