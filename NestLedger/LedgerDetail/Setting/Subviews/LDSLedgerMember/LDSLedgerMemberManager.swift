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

    let apiManager = APIManager()
    let ledgerId: String
    var ledgerData = LedgerData.initMock()
    var userInfos: [UserInfoData] = []
    var ledgerInvites: [LedgerInviteData] = []

    init(ledgerId: String) {
        self.ledgerId = ledgerId
        Task { await initData() }
    }

    private func initData() async {
        do {
            ledgerData = try await apiManager.getLedger(ledgerId: ledgerId)
            userInfos = try await apiManager.getMultipleUserInfo(userIds: ledgerData.userIds)

            ledgerInvites = try await apiManager.getLedgerInvites(ledgerId: ledgerId, receiveUserId: nil)
            await MainActor.run { vc?.tableView.reloadData() }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳目失敗")
        }
    }

    func getUserInfo(userId: String) async throws -> UserInfoData {
        try await apiManager.getUserByUid(uid: userId)
    }

    func getUserAvatar(userId: String) async -> UIImage? {
        try? await apiManager.getUserAvatar(userId: userId)
    }
}

// MARK: - LDSLMCellDelegate
extension LDSLedgerMemberManager: LDSLMCellDelegate, LDSLMInviteCellDelegate {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.vc?.present(vc, animated: true)
        }
    }

    func tapDeleteAction(userId: String) {
        print("✅ Delete user: \(userId)")
    }

    func deleteInviteUser(ledgerInviteId: String, indexPath: IndexPath?) {
        Task {
            do {
                try await apiManager.deleteLedgerInvite(ledgerInviteId: ledgerInviteId, type: .retriveLedgerInvite)
                await MainActor.run {
                    if let indexPath {
                        ledgerInvites.remove(at: indexPath.row)
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
                let inviteUserInfo = try await apiManager.getUserByEmailAddress(emailAddress: address)
                let ledgerInviteData = LedgerInviteData(ledgerId: ledgerId, sendUserId: sharedUserInfo.id, receiveUserId: inviteUserInfo.id)
                try await apiManager.createLedgerInvite(data: ledgerInviteData)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "成功發出邀請")
                }
            } catch {
                switch error {
                    case APIManager.UserInfoError.failedFetchUserInfo:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "使用者不存在")
                        }
                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
                        }
                }
            }
        }
    }
}
