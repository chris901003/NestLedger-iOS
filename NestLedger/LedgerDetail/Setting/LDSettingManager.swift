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

    let newApiManager = NewAPIManager()

    var ledgerData: LedgerData
    var ledgerTitle: String {
        get { ledgerData.title == "[Main]:\(newSharedUserInfo.id)" ? "我的帳本" : ledgerData.title }
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

        Task {
            do {
                ledgerData = try await newApiManager.leaveLedger(uid: newSharedUserInfo.id, ledgerId: ledgerData._id) ?? ledgerData
                newSharedUserInfo = try await newApiManager.getUserInfo()
                await MainActor.run {
                    vc?.dismiss(animated: true)
                    NLNotification.sendQuitLedger(ledgerId: ledgerData._id)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "離開帳本失敗")
            }
        }
    }

    func setMainLedger() {
        Task {
            do {
                newSharedUserInfo = try await newApiManager.changeQuickLogLedger(ledgerId: ledgerData._id)
                XOBottomBarInformationManager.showBottomInformation(type: .success, information: "設定成功")
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "設定失敗")
            }
        }
    }
}

// MARK: - LDSLedgerNameViewControllerDelegate
extension LDSettingManager: LDSLedgerNameViewControllerDelegate {
    func updateLedgerName(title: String) {
        guard !title.isEmpty else { return }
        ledgerData.title = title
        Task {
            do {
                ledgerData = try await newApiManager.updateLedger(data: LedgerUpdateRequestData(ledgerData))
                await MainActor.run {
                    vc?.tableView.reloadData()
                    NLNotification.sendUpdateLedger(ledgerData: ledgerData)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "更新帳本名稱失敗")
            }
        }
    }
}

// MARK: - LDSUserNickNameViewControllerDelegate
extension LDSettingManager: LDSUserNickNameViewControllerDelegate {
    func updateNickName(name: String) {
        guard !name.isEmpty else {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "暱稱不可為空")
            return
        }
        Task {
            do {
                ledgerData = try await newApiManager.setUserNickName(nickName: name, ledgerId: ledgerData._id)
                XOBottomBarInformationManager.showBottomInformation(type: .success, information: "已將暱稱更改為 \(name)")
                await MainActor.run { vc?.tableView.reloadData() }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "更新暱稱失敗")
            }
        }
    }
}
