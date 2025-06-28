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
    var avatarImage: UIImage?
    var newTitle: String = ""

    weak var vc: LSDTitleAndAvatarViewController?

    init(ledgerSplitData: LedgerSplitData) {
        self.ledgerSplitData = ledgerSplitData
    }

    func loadAvatar() async {
        guard let avatar = try? await newApiManager.getLedgerSplitAvatar(ledgerSplitId: ledgerSplitData._id) else { return }
        await MainActor.run {
            vc?.avatarView.image = avatar
        }
    }

    func save() async -> String? {
        return nil
    }
}
