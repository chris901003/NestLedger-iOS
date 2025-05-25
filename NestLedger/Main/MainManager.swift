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
        Task {
            do {
                try await fetchLedgerData()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: error.localizedDescription)
            }
        }
    }

    private func fetchLedgerData() async throws {
        guard let legerId = newSharedUserInfo.ledgerIds.first else { return }
        let ledgerData = try await newApiManager.getLedger(ledgerId: legerId)
        await MainActor.run {
            vc?.ledgerLabel.text = ledgerData.titleShow
        }
    }
}

extension MainManager {
    @objc private func receiveSetMainLedgerNotification(_ notification: Notification) {
        Task { try? await fetchLedgerData() }
    }
}
