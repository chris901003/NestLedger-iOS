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

    let manager = LedgerSplitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
        Task {
            await manager.loadMoreLedgerSplitData()
        }
    }

    private func setup() {
        manager.vc = self

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
            createLSVC.delegate = manager
            present(createLSVC, animated: true)
        }
        return UIMenu(title: "分帳本選單", children: [addNewLedgerSplitAction])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LedgerSplitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.ledgerSplitDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LSLedgerCell.cellId, for: indexPath) as? LSLedgerCell else {
            return UITableViewCell()
        }
        let data = manager.ledgerSplitDatas[indexPath.row]
        cell.config(ledgerSplitData: data, avatar: manager.ledgerSplitAvatars[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !manager.isLoading, indexPath.row == manager.ledgerSplitDatas.count - 1, manager.lastLoadIdx != manager.maxLoadIdx else { return }
        Task { await manager.loadMoreLedgerSplitData() }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = manager.ledgerSplitDatas[indexPath.row]
        let ledgerSplitVC = LedgerSplitDetailViewController(ledgerSplitData: data)
        ledgerSplitVC.delegate = manager
        navigationController?.pushViewController(ledgerSplitVC, animated: true)
    }
}
