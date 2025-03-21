// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class LedgerVCManager {
    let apiManager = APIManager()

    var ledgerIds: [String] = sharedUserInfo.ledgerIds
    var ledgerDatas: [LedgerData] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.vc?.collectionView.reloadData()
            }
        }
    }

    @MainActor var isLoading = false
    weak var vc: LedgerViewController?

    init() {
        Task {
            do {
                try await loadMoreLedgers()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "讀取帳本失敗")
            }
        }
    }

    func loadMoreLedgers() async throws {
        await MainActor.run { isLoading = true }
        let datas = try await withThrowingTaskGroup(of: LedgerData?.self, returning: [LedgerData].self) { group in
            let startIdx = ledgerDatas.count
            let endIdx = min(startIdx + 10, ledgerIds.count)
            for idx in startIdx..<endIdx {
                group.addTask { [weak self] in
                    guard let self else { return nil }
                    return try await apiManager.getLedger(ledgerId: ledgerIds[idx])
                }
            }
            let results = (try await group.reduce(into: [LedgerData]()) { $0.append($1) }).compactMap { $0 }
            return results
        }
        ledgerDatas.append(contentsOf: datas)
        await MainActor.run { isLoading = false }
    }
}
