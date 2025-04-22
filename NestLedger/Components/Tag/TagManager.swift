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
    let apiManager = APIManager()
    var ledgerId: String = ""
    var search: String? {
        didSet {
            page = 1
            showTags = []
            Task {
                do {
                    try await fetchMoreLedgerTags()
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "搜尋失敗")
                }
            }
        }
    }

    var showTags: [TagData] = []
    var page: Int = 1
    let limit: Int = 20
    var isLoading: Bool = false
    var isEnd: Bool = false

    weak var vc: TagViewController?

    init() {
        Task {
            do {
                guard let ledgerId = sharedUserInfo.ledgerIds.first else { return }
                self.ledgerId = ledgerId
                try await fetchMoreLedgerTags()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取標籤資訊失敗")
            }
            await MainActor.run {
                vc?.tableView.reloadData()
            }
        }
    }

    func fetchMoreLedgerTags() async throws {
        await MainActor.run { isLoading = true }
        let tags = try await apiManager.getTagsBy(ledgerId: ledgerId, search: search, page: page, limit: limit)
        showTags.append(contentsOf: tags)
        isEnd = tags.isEmpty
        page += 1
        await MainActor.run {
            isLoading = false
            vc?.tableView.reloadData()
        }
    }

    func createTag(tag: TagData) async -> TagData? {
        var tag = tag
        tag.ledgerId = ledgerId
        do {
            return try await apiManager.createTag(data: tag)
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "創建標籤失敗")
            return nil
        }
    }

    func deleteTag(tagId: String) async throws {
        try await apiManager.deleteTag(tagId: tagId)
    }
}
