// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class TagManager {
    let newApiManager = NewAPIManager()
    var ledgerId: String
    var search: String? {
        didSet {
            searchData = TagQueryRequestData(ledgerId: ledgerId, search: search, tagId: nil, page: 1, limit: limit)
            showTags = []
            Task {
                do {
                    try await fetchMoreLedgerTags()
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
                }
            }
        }
    }
    var searchData: TagQueryRequestData

    var showTags: [TagData] = []
    let limit: Int = 20
    var isLoading: Bool = false
    var isEnd: Bool = false

    weak var vc: TagViewController?

    init(ledgerId: String) {
        self.ledgerId = ledgerId
        self.searchData = TagQueryRequestData(ledgerId: ledgerId, search: nil, tagId: nil, page: 1, limit: limit)
        Task {
            do {
                try await fetchMoreLedgerTags()
            } catch NewAPIManager.NewAPIManagerError.unauthorizedError(_) {
                await MainActor.run {
                    vc?.dismiss(animated: true)
                    NLNotification.sendUnauthorizedLedger(ledgerId: ledgerId)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            }
            await MainActor.run {
                vc?.tableView.reloadData()
            }
        }
    }

    func fetchMoreLedgerTags() async throws {
        await MainActor.run { isLoading = true }
        let tags = try await newApiManager.queryTag(data: searchData)
        showTags.append(contentsOf: tags)
        isEnd = tags.isEmpty
        searchData.page = (searchData.page ?? 1) + 1
        await MainActor.run {
            isLoading = false
            vc?.tableView.reloadData()
        }
    }

    func createTag(tag: TagData) async -> TagData? {
        var tag = tag
        tag.ledgerId = ledgerId
        do {
            return try await newApiManager.createTag(data: TagCreateRequestData(tag))
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            return nil
        }
    }

    func deleteTag(tagId: String) async throws {
        try await newApiManager.deleteTag(tagId: tagId)
    }
}

// MARK: - TagEditViewControllerDelegate
extension TagManager: TagEditViewControllerDelegate {
    func updateTag(data: TagData, indexPath: IndexPath?) {
        if data.label.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "標籤更新失敗，標籤名稱不能為空")
            }
            return
        }

        Task {
            do {
                let updatedTagData = try await newApiManager.updateTag(data: TagUpdateRequestData(data))
                await MainActor.run {
                    if let indexPath,
                       let cell = vc?.tableView.cellForRow(at: indexPath) as? TagCell {
                        cell.config(color: updatedTagData.getColor, label: updatedTagData.label)
                    }
                    NLNotification.sendUpdateTag(tagData: updatedTagData)
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
                }
            }
        }
    }
}
