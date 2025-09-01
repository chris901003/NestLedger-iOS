// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension LSDMemberViewController {
    enum Sections: String {
        case join = "已加入"
        case waitingJoin = "等待加入"
    }
}

class LSDMemberViewController: UIViewController {
    let titleLabel = UILabel()
    let tableView = UITableView()

    let ledgerSplitDetailStore: LedgerSplitDetailStore
    let sections: [Sections] = [.join, .waitingJoin]

    init(store: LedgerSplitDetailStore) {
        ledgerSplitDetailStore = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
    }

    private func setup() {
        view.backgroundColor = .white

        titleLabel.text = "分帳本成員"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }

    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(LSDMemberCell.self, forCellReuseIdentifier: LSDMemberCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LSDMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return ledgerSplitDetailStore.data.userIds.count
            case 1:
                return 0
            default:
                return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LSDMemberCell.cellId, for: indexPath) as? LSDMemberCell else {
            return UITableViewCell()
        }
        cell.config(userId: ledgerSplitDetailStore.data.userIds[indexPath.row], type: .join)
        return cell
    }
}
