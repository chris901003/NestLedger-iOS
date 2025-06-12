// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class LDSCTLedgerManager {
    var ledgerData: [LedgerData] = []

    let newApiManager = NewAPIManager()
    weak var vc: LDSCTLedgerListViewController?

    @MainActor var isLoading = false

    @MainActor func loadMoreLedgerData() {
        guard !isLoading else { return }
        Task {
            await MainActor.run { isLoading = true }
            let ledgerIds = newSharedUserInfo.ledgerIds
            let startIdx = ledgerData.count
            let endIdx = min(startIdx + 10, ledgerIds.count)
            let targetLedgerIds = Array(ledgerIds[startIdx..<endIdx])

            do {
                let results = try await withThrowingTaskGroup(of: (LedgerData?, Int).self, returning: [LedgerData].self) { group in
                    for (idx, ledgerId) in targetLedgerIds.enumerated() {
                        group.addTask { [weak self] in
                            let ledgerData = try await self?.newApiManager.getLedger(ledgerId: ledgerId)
                            return (ledgerData, idx)
                        }
                    }

                    var results: [LedgerData?] = Array(repeating: LedgerData.initMock(), count: targetLedgerIds.count)
                    for try await result in group {
                        guard let ledgerData = result.0 else {
                            results[result.1] = nil
                            continue
                        }
                        results[result.1] = ledgerData
                    }
                    await MainActor.run { isLoading = false }
                    return results.compactMap { $0 }
                }
                ledgerData.append(contentsOf: results)
                await MainActor.run { vc?.tableView.reloadData() }
            } catch {
                await MainActor.run { isLoading = false }
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: "獲取更多帳本失敗")
            }
        }
    }
}
