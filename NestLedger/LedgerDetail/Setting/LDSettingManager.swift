// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class LDSettingManager {
    weak var vc: LDSettingViewController?

    var ledgerData: LedgerData
    var ledgerTitle: String {
        get { ledgerData.title == "[Main]:\(sharedUserInfo.id)" ? "我的帳本" : ledgerData.title }
    }

    init(ledgerData: LedgerData) {
        self.ledgerData = ledgerData
    }
}

// MARK: - LDSLedgerNameViewControllerDelegate
extension LDSettingManager: LDSLedgerNameViewControllerDelegate {
    func updateLedgerName(title: String) {
        guard !title.isEmpty else { return }
        ledgerData.title = title
        DispatchQueue.main.async { [weak self] in self?.vc?.tableView.reloadData() }
    }
}
