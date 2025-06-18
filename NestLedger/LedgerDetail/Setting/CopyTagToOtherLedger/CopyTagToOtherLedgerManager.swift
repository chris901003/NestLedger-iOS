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
                self?.vc?.targetTagView.hideHint()
                self?.loadMoreTargetLedgerTagDatas()
                self?.vc?.targetTagView.tableView.reloadData()
                self?.vc?.currentTagView.tableView.reloadData()
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
                vc?.targetTagView.isEnd = result.count < 20
                vc?.targetTagView.tableView.reloadData()
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
                vc?.currentTagView.isEnd = result.count < 20
                vc?.currentTagView.tableView.reloadData()
            }
        }
    }
}

// MARK: - LDSCTTargetTagViewDelegate
extension CopyTagToOtherLedgerManager: LDSCTTargetTagViewDelegate {
    func getNumberOfTargetTags() -> Int {
        newTagDatas.count + targetLedgerTagDatas.count
    }

    func getTagData(at index: Int) -> (tagData: TagData, isDeletable: Bool) {
        if index < newTagDatas.count {
            return (newTagDatas[index], true)
        } else {
            return (targetLedgerTagDatas[index - newTagDatas.count], false)
        }
    }

    func loadMoreTargetTag() {
        loadMoreTargetLedgerTagDatas()
    }

    func removeTag(tagData: TagData) {
        guard let index = newTagDatas.firstIndex(where: { $0._id == tagData._id }) else { return }
        newTagDatas.remove(at: index)
        DispatchQueue.main.async { [weak self] in
            self?.vc?.currentTagView.tableView.reloadData()
        }
    }
}

// MARK: - LDSCTCurrentTagViewDelegate
extension CopyTagToOtherLedgerManager: LDSCTCurrentTagViewDelegate {
    func getNumberOfCurrentTags() -> Int {
        currentLedgerTagDatas.count
    }

    func getTagData(at index: Int) -> (tagData: TagData, isSelected: Bool) {
        let isSelected = newTagDatas.contains { $0._id == currentLedgerTagDatas[index]._id }
        return (currentLedgerTagDatas[index], isSelected)
    }

    func loadMoreCurrentTag() {
        loadMoreCurrentLedgerTagDatas()
    }

    func tag(isSelected: Bool, tagId: String) {
        if isSelected {
            guard let tagData = (currentLedgerTagDatas.first { $0._id == tagId }) else { return }
            newTagDatas.append(tagData)
        } else {
            guard let index = newTagDatas.firstIndex(where: { $0._id == tagId }) else { return }
            newTagDatas.remove(at: index)
        }
        DispatchQueue.main.async { [weak self] in
            self?.vc?.targetTagView.tableView.reloadData()
        }
    }
}
