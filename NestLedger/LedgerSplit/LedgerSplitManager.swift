// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LedgerSplitManager {
    let newApiManager = NewAPIManager()
    var ledgerSplitDatas: [LedgerSplitData] = []
    var lastLoadIdx = 0
    var maxLoadIdx = 0
    @MainActor
    var isLoading = false

    weak var vc: LedgerSplitViewController?

    init() {
        lastLoadIdx = 0
        maxLoadIdx = newSharedUserInfo.ledgerSplitIds.count
    }

    func loadMoreLedgerSplitData() async {
        guard await !isLoading else { return }
        await MainActor.run { isLoading = true }
        do {
            let newLedgerSplitData = try await withThrowingTaskGroup(of: (Int, LedgerSplitData).self, returning: [LedgerSplitData].self) { group in
                let endIdx = min(lastLoadIdx + 20, maxLoadIdx)
                for idx in lastLoadIdx..<endIdx {
                    group.addTask {
                        let ledgerSplitData = try await self.newApiManager.getLedgerSplitData(ledgerSplitId: newSharedUserInfo.ledgerSplitIds[idx])
                        return (idx, ledgerSplitData)
                    }
                }
                var response = Array(repeating: LedgerSplitData.initMock(), count: endIdx - lastLoadIdx)
                for try await (idx, data) in group {
                    response[idx] = data
                }
                return response
            }
            lastLoadIdx += newLedgerSplitData.count
            await MainActor.run {
                isLoading = false
                ledgerSplitDatas.append(contentsOf: newLedgerSplitData)
                vc?.tableView.reloadData()
            }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            await MainActor.run {
                isLoading = false
            }
        }
    }
}
