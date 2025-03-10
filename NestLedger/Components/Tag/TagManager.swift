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
    var showTags: [TagData] = []

    weak var vc: TagViewController?

    init() {
        Task {
            do {
                try await fetchLedgerTags()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取標籤資訊失敗")
            }
            await MainActor.run {
                vc?.tableView.reloadData()
            }
        }
    }

    private func fetchLedgerTags() async throws {
        guard let ledgerId = sharedUserInfo.ledgerIds.first else { return }
        self.ledgerId = ledgerId
        showTags = try await apiManager.getTagsBy(ledgerId: ledgerId)
    }

    func createTag(tag: TagData) async {
        var tag = tag
        tag.ledgerId = ledgerId
        do {
            try await apiManager.createTag(data: tag)
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "創建標籤失敗")
        }
    }
}
