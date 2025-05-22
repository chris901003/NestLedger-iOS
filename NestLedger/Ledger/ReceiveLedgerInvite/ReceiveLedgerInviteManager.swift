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
    let newApiManager = NewAPIManager()

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
        ledgerInviteDatas = try await newApiManager.getLedgerInvite(ledgerId: nil, receiveUserId: newSharedUserInfo.id)
    }

    func fetchLedgerData(ledgerInviteData: LedgerInviteData) async throws -> LedgerData {
        try await newApiManager.getLedger(ledgerId: ledgerInviteData.ledgerId)
    }

    func fetchUserInfo(ledgerInviteData: LedgerInviteData) async throws -> UserInfoData {
        try await newApiManager.getUserInfoByUid(uid: ledgerInviteData.sendUserId)
    }

    func fetchUserAvatar(userUid: String) async throws -> UIImage? {
        try await newApiManager.getUserAvatar(uid: userUid)
    }
}

// MARK: - RLICellDelegate
extension ReceiveLedgerInviteManager: RLICellDelegate {
    func acceptInvite(ledgerInviteData: LedgerInviteData, indexPath: IndexPath?) {
        Task {
            await MainActor.run { sharedUserInfo.ledgerIds.append(ledgerInviteData.ledgerId) }
            do {
                try await newApiManager.deleteLedgerInvite(inviteId: ledgerInviteData._id, accept: true)
                await MainActor.run {
                    removeCellAnimation(indexPath, ledgerInviteData._id)
                    vc?.delegate?.joinLedger(ledgerId: ledgerInviteData.ledgerId)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "加入帳本失敗")
            }
        }
    }

    func rejectInvite(ledgerInviteData: LedgerInviteData, indexPath: IndexPath?) {
        Task {
            do {
                try await newApiManager.deleteLedgerInvite(inviteId: ledgerInviteData._id, accept: false)
                await removeCellAnimation(indexPath, ledgerInviteData._id)
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "拒絕加入帳本失敗")
            }
        }
    }

    @MainActor
    func removeCellAnimation(_ indexPath: IndexPath?, _ id: String) {
        if let indexPath,
           let idx = (ledgerInviteDatas.firstIndex { $0._id == id }) {
            ledgerInviteDatas.remove(at: idx)
            vc?.tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
