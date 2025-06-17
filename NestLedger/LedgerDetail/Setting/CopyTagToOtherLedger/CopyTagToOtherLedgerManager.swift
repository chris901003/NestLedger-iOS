// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class CopyTagToOtherLedgerManager {
    var currentLedgerId: String
    var targetLedgerId: String? {
        didSet {
            targetLedgerTagDatas.removeAll()
            newTagDatas.removeAll()
            DispatchQueue.main.async { [weak self] in
                self?.vc?.targetTagView.removeAll()
                self?.loadMoreTargetLedgerTagDatas()
            }
        }
    }

    var targetLedgerTagDatas: [TagData] = []
    var newTagDatas: [TagData] = []

    var currentLedgerTagDatas: [TagData] = []

    let newApiManager = NewAPIManager()
    weak var vc: CopyTagToOtherLedgerViewController?

    init(ledgerId currentLedgerId: String) {
        self.currentLedgerId = currentLedgerId
    }

    private func loadMoreTargetLedgerTagDatas() {
        guard let targetLedgerId else { return }
        Task {
            let page = targetLedgerTagDatas.count / 20
            let queryRequestData = TagQueryRequestData(ledgerId: targetLedgerId, search: nil, tagId: nil, page: page, limit: 20)
            let result = try await newApiManager.queryTag(data: queryRequestData)
            targetLedgerTagDatas.append(contentsOf: result)
            await MainActor.run {
                vc?.targetTagView.receiveTagData(tagDatas: result)
            }
        }
    }

    private func loadMoreCurrentLedgerTagDatas() {
        Task {
            let page = currentLedgerTagDatas.count / 20
            let queryRequestData = TagQueryRequestData(ledgerId: currentLedgerId, search: nil, tagId: nil, page: page, limit: 20)
            let result = try await newApiManager.queryTag(data: queryRequestData)
            currentLedgerTagDatas.append(contentsOf: result)
            await MainActor.run {
                vc?.currentTagView.receiveTagData(tagDatas: result)
            }
        }
    }
}

// MARK: - LDSCTTargetTagViewDelegate
extension CopyTagToOtherLedgerManager: LDSCTTargetTagViewDelegate {
    func loadMoreTargetTag() {
        loadMoreTargetLedgerTagDatas()
    }
}

// MARK: - LDSCTCurrentTagViewDelegate
extension CopyTagToOtherLedgerManager: LDSCTCurrentTagViewDelegate {
    func loadMoreCurrentTag() {
        loadMoreCurrentLedgerTagDatas()
    }
}
