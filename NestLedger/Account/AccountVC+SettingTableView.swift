// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI
import SafariServices

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    enum SettingSectionType: String {
        case basic = "基礎設定"
        case account = "帳號設定"
        case information = "更多資訊"
    }

    enum SettingRowType: String {
        // Basic Section
        case timeZone = "時區"
        // Account Section
        case logout = "登出"
        case deleteAccount = "刪除帳號"
        // Information Section
        case author = "作者"
        case privacy = "隱私權"
        case contactUs = "聯絡我們"
        case copyright = "版權"
    }

    static let sections: [AccountViewController.SettingSectionType] = [
        .basic, .account, .information
    ]

    static let rows: [[AccountViewController.SettingRowType]] = [
        [.timeZone],
        [.logout, .deleteAccount],
        [.author, .privacy, .contactUs, .copyright]
    ]

    func numberOfSections(in tableView: UITableView) -> Int {
        AccountViewController.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AccountViewController.rows[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        AccountViewController.sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = AccountViewController.rows[indexPath.section][indexPath.row]
        var cell = UITableViewCell()
        switch rowType {
            case .timeZone, .privacy:
                cell = settingTableView.dequeueReusableCell(withIdentifier: titleInfoIconCellId, for: indexPath)
            case .logout, .deleteAccount:
                cell = settingTableView.dequeueReusableCell(withIdentifier: centerLabelCellId, for: indexPath)
            case .author, .contactUs, .copyright:
                cell = settingTableView.dequeueReusableCell(withIdentifier: titleInfoCellId, for: indexPath)
                cell.selectionStyle = .none
        }
        switch rowType {
            case .timeZone:
                guard let cell = cell as? XOLeadingTrailingLabelWithIconCell else { return cell }
                cell.config(title: rowType.rawValue, info: "GMT\(manager.userInfo.timeZone > 0 ? "+" : "")\(manager.userInfo.timeZone)")
            case .logout:
                guard let cell = cell as? XOCenterLabelCell else { return cell }
                cell.config(label: rowType.rawValue, font: .systemFont(ofSize: 16, weight: .semibold), color: .systemBlue)
            case .deleteAccount:
                guard let cell = cell as? XOCenterLabelCell else { return cell }
                cell.config(label: rowType.rawValue, font: .systemFont(ofSize: 16, weight: .semibold), color: .systemRed)
            case .author:
                guard let cell = cell as? XOLeadingTrailingLabelCell else { return cell }
                cell.config(title: rowType.rawValue, info: "Zephyr-Huang")
            case .privacy:
                guard let cell = cell as? XOLeadingTrailingLabelWithIconCell else { return cell }
                cell.config(title: rowType.rawValue, info: "", iconName: "safari")
            case .contactUs:
                guard let cell = cell as? XOLeadingTrailingLabelCell else { return cell }
                cell.config(title: rowType.rawValue, info: "service@xxooooxx.org")
            case .copyright:
                guard let cell = cell as? XOLeadingTrailingLabelCell else { return cell }
                cell.config(title: rowType.rawValue, info: "Copyright © 2025 Zephyr Huang")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = AccountViewController.rows[indexPath.section][indexPath.row]
        switch rowType {
            case .timeZone:
                let timeZoneSelectVC = XOTimeZoneSelectViewController()
                timeZoneSelectVC.delegate = self
                timeZoneSelectVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(timeZoneSelectVC, animated: true)
            case .logout:
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                let logoutAction = UIAlertAction(title: "登出", style: .destructive) { [weak self] _ in
                    self?.manager.logout()
                }
                let alertController = UIAlertController(title: "登出", message: "登出後將不再收到通知", preferredStyle: .alert)
                alertController.addAction(cancelAction)
                alertController.addAction(logoutAction)
                present(alertController, animated: true)
            case .deleteAccount:
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { _ in
                    print("✅ Delete Action")
                }
                let alertController = UIAlertController(title: "刪除帳號", message: "刪除帳號後所有資料將移除", preferredStyle: .alert)
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                present(alertController, animated: true)
            case .privacy:
                guard let url = URL(string: "https://www.zephyrhuang.org/nestledger-ios/") else { return }
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            default:
                break
        }
    }
}

// MARK: - XOTimeZoneSelectViewControllerDelegate
extension AccountViewController: XOTimeZoneSelectViewControllerDelegate {
    func selectedTimeZone(gmtOffsetHours: Int) {
        manager.userInfo.timeZone = gmtOffsetHours
        Task { await MainActor.run { settingTableView.reloadData() } }
        navigationController?.popViewController(animated: true)
    }
}
