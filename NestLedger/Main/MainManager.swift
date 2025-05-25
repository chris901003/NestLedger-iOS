// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class MainManager {
    let newApiManager = NewAPIManager()
    weak var vc: MainViewController?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSetMainLedgerNotification), name: .setMainLedger, object: nil)
        fetchLedgerTitle()
    }

    private func fetchLedgerTitle() {
        guard let legerId = newSharedUserInfo.ledgerIds.first else { return }
        Task {
            do {
                let ledgerData = try await newApiManager.getLedger(ledgerId: legerId)
                await MainActor.run {
                    vc?.ledgerLabel.text = ledgerData.titleShow
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: error.localizedDescription)
            }
        }
    }

    func refreshData() {
        Task {
            do {
                let beforeLedgerId = newSharedUserInfo.ledgerIds.first
                newSharedUserInfo = try await newApiManager.getUserInfo()
                fetchLedgerTitle()
                await MainActor.run {
                    if beforeLedgerId != newSharedUserInfo.ledgerIds.first {
                        // 若更改 quick ledger 則在 shared user info 中會有 notification，其他部分會自動更新
                        XOBottomBarInformationManager.showBottomInformation(type: .info, information: "已被踢除原先的帳本")
                    } else {
                        // 只有在 quick ledger 沒有被更改時發出 refresh 訊息
                        NotificationCenter.default.post(name: .refreshMainView, object: nil, userInfo: nil)
                    }
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: error.localizedDescription)
            }
        }
    }
}

// MARK: - Receive set main ledger notification
extension MainManager {
    @objc private func receiveSetMainLedgerNotification(_ notification: Notification) {
        fetchLedgerTitle()
    }
}
