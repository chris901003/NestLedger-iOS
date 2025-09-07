// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Combine

class LSDSettingManager {
    let ledgerSplitDetailStore: LedgerSplitDetailStore
    var cancellables: Set<AnyCancellable> = []
    let newAPIManager = NewAPIManager()

    weak var vc: LSDSettingViewController?

    init(ledgerSplitDetailStore: LedgerSplitDetailStore) {
        self.ledgerSplitDetailStore = ledgerSplitDetailStore
        subscribeLedgerSplitData()
    }

    private func subscribeLedgerSplitData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            ledgerSplitDetailStore.dataPublisher
                .sink { [weak self] _ in
                    self?.vc?.tableView.reloadData()
                }
                .store(in: &cancellables)
        }
    }

    func leaveLedgerSplit() async throws {
        try await newAPIManager.leaveLedgerSplit(ledgerSplitId: ledgerSplitDetailStore.data._id, userId: newSharedUserInfo.id)
    }
}
