// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/15.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class LDSettingManager {
    weak var vc: LDSettingViewController?

    let apiManager = APIManager()

    var ledgerData: LedgerData
    var ledgerTitle: String {
        get { ledgerData.title == "[Main]:\(sharedUserInfo.id)" ? "我的帳本" : ledgerData.title }
    }
    var isMainLedger: Bool { get { ledgerData.title.hasPrefix("[Main]") } }

    init(ledgerData: LedgerData) {
        self.ledgerData = ledgerData
    }

    func quitLedger() {
        if isMainLedger {
            XOBottomBarInformationManager.showBottomInformation(type: .info, information: "無法離開主帳本")
            return
        }

        if let idx = ledgerData.userIds.firstIndex(of: sharedUserInfo.id) {
            ledgerData.userIds.remove(at: idx)
            Task {
                do {
                    try await apiManager.updateLedger(ledgerData: ledgerData)
                    if let idx = sharedUserInfo.ledgerIds.firstIndex(of: ledgerData._id) {
                        sharedUserInfo.ledgerIds.remove(at: idx)
                        try await apiManager.updateUserInfo(sharedUserInfo)
                    }
                    await MainActor.run {
                        vc?.dismiss(animated: true)
                        NLNotification.sendQuitLedger(ledgerId: ledgerData._id)
                    }
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "離開帳本失敗")
                }
            }
        }
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
