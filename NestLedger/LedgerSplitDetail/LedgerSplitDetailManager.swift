// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class LedgerSplitDetailManager {
    let newApiManager = NewAPIManager()
    let ledgerSplitDetailStore: LedgerSplitDetailStore

    init(dataStore: LedgerSplitDetailStore) {
        self.ledgerSplitDetailStore = dataStore
    }

    func loadAvatar() async {
        guard let avatar = try? await newApiManager.getLedgerSplitAvatar(ledgerSplitId: ledgerSplitDetailStore.data._id) else { return }
        await MainActor.run {
            ledgerSplitDetailStore.update(avatar: avatar)
        }
    }
}
