// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSLedgerMemberViewController: UIViewController {
    let addNewMemberView = LDSLMAddNewMemberView()
    let tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "帳目成員"

        tableView.delegate = self
        tableView.dataSource = self
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSLedgerMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Just for test"
        return cell
    }
}
