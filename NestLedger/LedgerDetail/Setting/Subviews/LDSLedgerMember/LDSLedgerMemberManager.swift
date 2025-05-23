// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LDSLedgerMemberManager {
    weak var vc: LDSLedgerMemberViewController?

    let newApiManager = NewAPIManager()
    let ledgerId: String
    var ledgerData = LedgerData.initMock()
    var userInfos: [UserInfoData] = []
    var ledgerInvites: [LedgerInviteData] = []

    var isMainLedger: Bool { get { ledgerData.title.hasPrefix("[Main]") } }

    init(ledgerId: String) {
        self.ledgerId = ledgerId
        Task { await initData() }
    }

    private func initData() async {
        do {
            ledgerData = try await newApiManager.getLedger(ledgerId: ledgerId)
            userInfos = try await newApiManager.getMultipleUserInfo(uids: ledgerData.userIds)

            ledgerInvites = try await newApiManager.getLedgerInvite(ledgerId: ledgerId, receiveUserId: nil)
            await MainActor.run { vc?.tableView.reloadData() }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳目失敗")
        }
    }

    func getUserInfo(userId: String) async throws -> UserInfoData {
        try await newApiManager.getUserInfoByUid(uid: userId)
    }

    func getUserAvatar(userId: String) async -> UIImage? {
        try? await newApiManager.getUserAvatar(uid: userId)
    }
}

// MARK: - LDSLMCellDelegate
extension LDSLedgerMemberManager: LDSLMCellDelegate, LDSLMInviteCellDelegate {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.vc?.present(vc, animated: true)
        }
    }

    func tapDeleteAction(userId: String, indexPath: IndexPath?) {
        if newSharedUserInfo.id == userId {
            XOBottomBarInformationManager.showBottomInformation(type: .info, information: "無法將自己從帳本中移除")
            return
        }
        Task {
            do {
                _ = try await newApiManager.leaveLedger(uid: userId, ledgerId: ledgerId)
                await MainActor.run {
                    if let indexPath,
                       let idx = (userInfos.firstIndex { $0.id == userId }) {
                           userInfos.remove(at: idx)
                           vc?.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "刪除成員失敗")
            }
        }
    }

    func deleteInviteUser(ledgerInviteId: String, indexPath: IndexPath?) {
        Task {
            do {
                try await newApiManager.deleteLedgerInvite(inviteId: ledgerInviteId, accept: false)
                await MainActor.run {
                    if let indexPath,
                       let idx = (ledgerInvites.firstIndex { $0._id == ledgerInviteId }) {
                        ledgerInvites.remove(at: idx)
                        vc?.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            }
        }
    }
}

// MARK: - LDSLMEnterNewMemberDelegate
extension LDSLedgerMemberManager: LDSLMEnterNewMemberDelegate {
    func sendLedgerInvite(address: String) {
        guard !address.isEmpty else { return }
        Task {
            do {
                let inviteUserInfo = try await newApiManager.getUserByEmail(emailAddress: address)
                let ledgerInviteData = try await newApiManager.createLedgerInvite(
                    data: .init(ledgerId: ledgerId, sendUserId: newSharedUserInfo.id, receiveUserId: inviteUserInfo.id))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self else { return }
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "成功發出邀請")
                    ledgerInvites.append(ledgerInviteData)
                    vc?.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
                }
            }
        }
    }
}
