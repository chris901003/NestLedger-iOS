// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSDTitleAndAvatarManager {
    let newApiManager = NewAPIManager()
    let ledgerSplitData: LedgerSplitData
    var avatarImage: UIImage
    var newTitle: String = ""
    var newAvatar: UIImage?

    weak var vc: LSDTitleAndAvatarViewController?

    init(ledgerSplitData: LedgerSplitData, avatarImage: UIImage) {
        self.ledgerSplitData = ledgerSplitData
        self.avatarImage = avatarImage
        self.newTitle = ledgerSplitData.title
    }
}

// MARK: - Update Ledger Split
extension LSDTitleAndAvatarManager {
    func save() async throws -> (LedgerSplitData, UIImage?) {
        if let response = filterIsUpdateValid() {
            throw BasicError.common(msg: response)
        }
        do {
            let updatedLedgerSplitData = try await updateLedgerSplitIfNeeded()
            try await updateAvatarIfNeeded()
            return (updatedLedgerSplitData, newAvatar ?? avatarImage)
        } catch {
            throw BasicError.common(msg: "更新分帳本失敗")
        }
    }

    private func filterIsUpdateValid() -> String? {
        if newTitle.isEmpty { return "分帳本名稱不可為空白" }
        return nil
    }

    private func updateLedgerSplitIfNeeded() async throws -> LedgerSplitData {
        guard newTitle != ledgerSplitData.title else { return ledgerSplitData}
        let updateLedgerSplitData = LedgerSplitUpdateRequestData(_id: ledgerSplitData._id, title: newTitle)
        return try await newApiManager.updateLedgerSplit(ledgerSplitUpdateData: updateLedgerSplitData)
    }

    private func updateAvatarIfNeeded() async throws {
        guard let image = newAvatar else { return }
        try await newApiManager.uploadLedgerSplitAvatar(ledgerSplitId: ledgerSplitData._id, avatar: image)
    }
}
