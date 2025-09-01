// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LedgerSplitJoinManager {
    let newAPIManager = NewAPIManager()

    func getLedgerSplitData(
        ledgerSplitId: String,
        token: String
    ) async throws -> (ledgerSplitData: LedgerSplitData, avatar: UIImage?) {
        let ledgerSplitData = try await newAPIManager.getLedgerSplitByInviteToken(ledgerSplitId: ledgerSplitId, token: token)
        let ledgerSplitAvatar = try? await newAPIManager.getLedgerSplitAvatar(ledgerSplitId: ledgerSplitId)
        return (ledgerSplitData, ledgerSplitAvatar)
    }

    func joinLedgerSplit(token: String) async throws {
        let userInfoData = try await newAPIManager.ledgerSplitLinkInvite(token: token)
        newSharedUserInfo = userInfoData
    }
}
