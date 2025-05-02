// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/5/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI
import UIKit

class ReceiveLedgerInviteManager {
    let apiManager = APIManager()

    var ledgerInviteDatas: [LedgerInviteData] = []
    weak var vc: ReceiveLedgerInviteViewController?

    init() {
        initData()
    }

    private func initData() {
        Task {
            do {
                try await loadLedgerInviteData()
                await MainActor.run { vc?.tableView.reloadData() }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            }
        }
    }

    private func loadLedgerInviteData() async throws {
        ledgerInviteDatas = try await apiManager.getLedgerInvites(ledgerId: nil, receiveUserId: sharedUserInfo.id)
    }

    func fetchLedgerData(ledgerInviteData: LedgerInviteData) async throws -> LedgerData {
        try await apiManager.getLedger(ledgerId: ledgerInviteData.ledgerId)
    }

    func fetchUserInfo(ledgerInviteData: LedgerInviteData) async throws -> UserInfoData {
        try await apiManager.getUserByUid(uid: ledgerInviteData.sendUserId)
    }

    func fetchUserAvatar(userUid: String) async throws -> UIImage? {
        try await apiManager.getUserAvatar(userId: userUid)
    }
}

// MARK: - RLICellDelegate
extension ReceiveLedgerInviteManager: RLICellDelegate {
    func acceptInvite(ledgerInviteData: LedgerInviteData, indexPath: IndexPath?) {
        Task {
            await MainActor.run { sharedUserInfo.ledgerIds.append(ledgerInviteData._id) }
            do {
                try await apiManager.deleteLedgerInvite(ledgerInviteId: ledgerInviteData._id, type: .acceptLedgerInvite)
                try await apiManager.updateUserInfo(sharedUserInfo)
                await MainActor.run {
                    if let indexPath,
                       let idx = (ledgerInviteDatas.firstIndex { $0._id == ledgerInviteData._id }) {
                        // TODO: Send Notification Udate Ledger List
                        ledgerInviteDatas.remove(at: idx)
                        vc?.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "加入帳本失敗")
            }
        }
    }

    func rejectInvite(ledgerInviteData: LedgerInviteData, indexPath: IndexPath?) {
        print("✅ Reject invite")
    }
}
