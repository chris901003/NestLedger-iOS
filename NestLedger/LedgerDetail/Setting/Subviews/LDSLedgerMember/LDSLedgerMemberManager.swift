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

    init(ledgerId: String) {
        self.ledgerId = ledgerId
        Task { await initData() }
    }

    private func initData() async {
        do {
            ledgerData = try await apiManager.getLedger(ledgerId: ledgerId)
            userInfos = try await apiManager.getMultipleUserInfo(userIds: ledgerData.userIds)
            await MainActor.run { vc?.tableView.reloadData() }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取帳目失敗")
        }
    }

    func getUserAvatar(userId: String) async -> UIImage? {
        try? await apiManager.getUserAvatar(userId: userId)
    }
}

// MARK: - LDSLMCellDelegate
extension LDSLedgerMemberManager: LDSLMCellDelegate {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.vc?.present(vc, animated: true)
        }
    }

    func tapDeleteAction(userId: String) {
        print("✅ Delete user: \(userId)")
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
            } catch {
                print("✅ Error: \(error.localizedDescription)")
            }
        }
    }
}
