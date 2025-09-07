// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class LSDMemberManager {
    let newAPIManager = NewAPIManager()
    let ledgerSplitDetailStore: LedgerSplitDetailStore
    weak var vc: LSDMemberViewController?

    var userInviteDatas: [LedgerSplitUserInviteData] = []

    init(ledgerSplitDetailStore: LedgerSplitDetailStore) {
        self.ledgerSplitDetailStore = ledgerSplitDetailStore
    }

    func loadUserInviteSend() async throws {
        userInviteDatas = try await newAPIManager.ledgerSplitGetUserInviteSend(ledgerSplitId: ledgerSplitDetailStore.data._id)
    }
}

// MARK: - LSDAddInviteViewControllerDelegate
extension LSDMemberManager: LSDAddInviteViewControllerDelegate {
    func newLedgerSplitUserInvite(data: LedgerSplitUserInviteData) {
        userInviteDatas.append(data)
        vc?.tableView.reloadData()
    }
}
