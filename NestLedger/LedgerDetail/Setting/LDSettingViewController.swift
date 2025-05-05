// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

fileprivate enum LDSSection: String, CaseIterable {
    case base = "基礎"
    case member = "成員"
}

fileprivate enum LDSRow: String, CaseIterable {
    // [base]
    case name = "帳本名稱"
    case tag = "標籤管理"
    case setMainLedger = "設為快速記帳帳本"

    // [member]
    case member = "帳本成員"
    case exit = "退出帳本"

    static func getRows(_ section: LDSSection) -> [LDSRow] {
        switch section {
            case .base:
                return [.name, .tag, .setMainLedger]
            case .member:
                return [.member, .exit]
        }
    }
}

class LDSettingViewController: UIViewController {
    let manager: LDSettingManager

    let topBarView = UIView()
    let titleLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(ledgerData: LedgerData) {
        self.manager = LDSettingManager(ledgerData: ledgerData)
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

        topBarView.backgroundColor = .systemGray5
        topBarView.layer.cornerRadius = 2.0

        titleLabel.text = "帳本設定"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1

        tableView.layer.cornerRadius = 15.0
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBarView.widthAnchor.constraint(equalToConstant: 30),
            topBarView.heightAnchor.constraint(equalToConstant: 4)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(XOLeadingTrailingLabelCell.self, forCellReuseIdentifier: XOLeadingTrailingLabelCell.cellId)
        tableView.register(XOLeadingTrailingLabelWithIconCell.self, forCellReuseIdentifier: XOLeadingTrailingLabelWithIconCell.cellId)
        tableView.register(XOCenterLabelCell.self, forCellReuseIdentifier: XOCenterLabelCell.cellId)
    }
}

// MARK: - UITableView Delegate
extension LDSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        LDSSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LDSRow.getRows(LDSSection.allCases[section]).count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        LDSSection.allCases[section].rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = LDSRow.getRows(LDSSection.allCases[indexPath.section])[indexPath.row]
        switch row {
            case .name:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOLeadingTrailingLabelCell.cellId, for: indexPath) as? XOLeadingTrailingLabelCell {
                    cell.config(title: row.rawValue, info: manager.ledgerTitle)
                    return cell
                }
            case .tag:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOLeadingTrailingLabelWithIconCell.cellId, for: indexPath) as? XOLeadingTrailingLabelWithIconCell {
                    cell.config(title: row.rawValue, info: "")
                    return cell
                }
            case .setMainLedger:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOCenterLabelCell.cellId, for: indexPath) as? XOCenterLabelCell {
                    cell.config(label: row.rawValue, font: .systemFont(ofSize: 16, weight: .semibold), color: .systemBlue)
                    return cell
                }
            case .member:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOLeadingTrailingLabelWithIconCell.cellId, for: indexPath) as? XOLeadingTrailingLabelWithIconCell {
                    cell.config(title: row.rawValue, info: "1")
                    return cell
                }
            case .exit:
                if let cell = tableView.dequeueReusableCell(withIdentifier: XOCenterLabelCell.cellId, for: indexPath) as? XOCenterLabelCell {
                    cell.config(label: row.rawValue, font: .systemFont(ofSize: 16, weight: .semibold), color: .red)
                    return cell
                }
        }
        let cell = UITableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = LDSRow.getRows(LDSSection.allCases[indexPath.section])[indexPath.row]
        switch row {
            case .name:
                let nameVC = LDSLedgerNameViewController(title: manager.ledgerTitle, isVariable: manager.ledgerTitle == manager.ledgerData.title)
                nameVC.delegate = manager
                navigationController?.pushViewController(nameVC, animated: true)
            case .tag:
                let tagVC = TagViewController(type: .editTag, ledgerId: manager.ledgerData._id)
                navigationController?.pushViewController(tagVC, animated: true)
            case .setMainLedger:
                manager.setMainLedger()
            case .member:
                let memberVC = LDSLedgerMemberViewController(ledgerId: manager.ledgerData._id)
                navigationController?.pushViewController(memberVC, animated: true)
            case .exit:
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                let deleteAction = UIAlertAction(title: "退出", style: .destructive) { [weak self] _ in
                    guard let self else { return }
                    manager.quitLedger()
                }
                let controller = UIAlertController(title: "退出帳本", message: "您確定要退出此帳本嗎?", preferredStyle: .alert)
                controller.addAction(cancelAction)
                controller.addAction(deleteAction)
                present(controller, animated: true)
        }
    }
}
