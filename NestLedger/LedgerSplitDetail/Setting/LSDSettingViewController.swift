// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

extension LSDSettingViewController {
    enum Section: String, CaseIterable {
        case basic = "基本設定"
        case user = "成員"
    }

    enum Row: String, CaseIterable {
        // [Basic]
        case nameAndAvatar = "分帳本名稱與照片"

        // [user]
        case inviteQRCode = "加入分帳本 QRCode"
        case members = "分帳本成員"
    }
}

class LSDSettingViewController: UIViewController {
    let barView = UIView()
    let titleLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    let sections: [Section] = [.basic, .user]
    let rows: [[Row]] = [[.nameAndAvatar], [.inviteQRCode, .members]]
    let ledgerSplitDetailStore: LedgerSplitDetailStore
    let manager: LSDSettingManager

    init(ledgerSplitDetailStore: LedgerSplitDetailStore) {
        self.ledgerSplitDetailStore = ledgerSplitDetailStore
        manager = LSDSettingManager(ledgerSplitDetailStore: ledgerSplitDetailStore)
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
        manager.vc = self
        view.backgroundColor = .white

        barView.backgroundColor = .systemGray4
        barView.layer.cornerRadius = 4

        titleLabel.text = "分帳本設定"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        tableView.layer.cornerRadius = 15.0
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            barView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barView.heightAnchor.constraint(equalToConstant: 6),
            barView.widthAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(XOLeadingTrailingLabelCell.self, forCellReuseIdentifier: XOLeadingTrailingLabelCell.cellId)
        tableView.register(XOLeadingTrailingLabelWithIconCell.self, forCellReuseIdentifier: XOLeadingTrailingLabelWithIconCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LSDSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = rows[indexPath.section][indexPath.row]
        switch cellType {
            case .nameAndAvatar:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOLeadingTrailingLabelCell.cellId, for: indexPath) as? XOLeadingTrailingLabelCell {
                    cell.config(title: cellType.rawValue, info: ledgerSplitDetailStore.data.title)
                    return cell
                }
            case .inviteQRCode:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOLeadingTrailingLabelWithIconCell.cellId, for: indexPath) as? XOLeadingTrailingLabelWithIconCell {
                    cell.config(title: cellType.rawValue, info: "", iconName: "qrcode")
                    return cell
                }
            case .members:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOLeadingTrailingLabelWithIconCell.cellId, for: indexPath) as? XOLeadingTrailingLabelWithIconCell {
                    cell.config(title: cellType.rawValue, info: "1")
                    return cell
                }
        }
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = rows[indexPath.section][indexPath.row]
        switch cellType {
            case .nameAndAvatar:
                let titleAndAvatarVC = LSDTitleAndAvatarViewController(ledgerSplitDetailStore: ledgerSplitDetailStore)
                navigationController?.pushViewController(titleAndAvatarVC, animated: true)
            case .inviteQRCode:
                let inviteQRCodeVC = LSDInviteQRCodeViewController(ledgerSplitData: ledgerSplitDetailStore.data)
                navigationController?.pushViewController(inviteQRCodeVC, animated: true)
            case .members:
                let memberVC = LSDMemberViewController(store: ledgerSplitDetailStore)
                navigationController?.pushViewController(memberVC, animated: true)
        }
    }
}
