// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LedgerSplitViewController: UIViewController {
    let plusButton = LPlusButtonView()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
    }

    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "分帳本列表"

        plusButton.showsMenuAsPrimaryAction = true
        plusButton.menu = createMenu()
        plusButton.config(infoCount: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(LSLedgerCell.self, forCellReuseIdentifier: LSLedgerCell.cellId)
    }

    private func createMenu() -> UIMenu {
        let addNewLedgerSplitAction = UIAction(title: "新增分帳本") { [weak self] _ in
            guard let self else { return }
            let createLSVC = LSCreateViewController()
            createLSVC.modalPresentationStyle = .overCurrentContext
            createLSVC.modalTransitionStyle = .crossDissolve
            present(createLSVC, animated: true)
        }
        return UIMenu(title: "分帳本選單", children: [addNewLedgerSplitAction])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LedgerSplitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LSLedgerCell.cellId, for: indexPath) as? LSLedgerCell else {
            return UITableViewCell()
        }
        return cell
    }
}
