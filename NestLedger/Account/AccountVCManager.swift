// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import FirebaseAuth
import UIKit
import xxooooxxCommonFunction
import xxooooxxCommonUI

class AccountVCManager {
    weak var controller: AccountViewController?

    let newApiManager = NewAPIManager()
    var userInfo = UserInfoData.initMock() {
        didSet {
            if !startUpdate { return }
            newSharedUserInfo = userInfo
            Task {
                let _ = try? await newApiManager.updateUserInfo(
                    requestData: UserInfoUpdateRequestData(userInfo)
                )
                await MainActor.run {
                    XOBottomBarInformationManager.showBottomInformation(type: .success,information: "資料已更新")
                }
            }
        }
    }
    var avatar: UIImage? {
        didSet {
            if !startUpdate { return }
            guard let image = avatar else { return }
            Task {
                do {
                    let userInfoData = try await newApiManager.uploadUserAvatar(image: image)
                    self.userInfo.avatar = userInfoData.avatar
                } catch {
                    await MainActor.run {
                        XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "更新頭像失敗")
                    }
                }
            }
        }
    }
    var basicInformation = BasicInformationData()
    var startUpdate = false
    var emailVerificationData: EmailVerificationData?

    init() {
        Task {
            await getBasicInformation()
            await getUserInfo()
            await getAvatar()
            await getEmailVerification()
            await MainActor.run {
                controller?.settingTableView.reloadData()
                controller?.config()
                startUpdate = true
            }
        }
    }

    private func getBasicInformation() async {
        do {
            basicInformation = try await newApiManager.getBasicInformation()
        } catch {
            await MainActor.run {
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: "無法取得最新資訊")
            }
        }
    }

    private func getUserInfo() async {
        do {
            userInfo = try await newApiManager.getUserInfo()
        } catch {
            await MainActor.run {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取得帳號資訊")
            }
        }
    }

    private func getAvatar() async {
        do {
            let image = try await newApiManager.getUserAvatar(uid: userInfo.id)
            avatar = image
        } catch {
            await MainActor.run {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取的頭像")
            }
        }
    }

    private func getEmailVerification() async {
        guard let emailVerificationData = try? await newApiManager.getEmailVerification() else { return }
        if emailVerificationData.expireAt.timeIntervalSince1970 - Date.now.timeIntervalSince1970 > 0 {
            self.emailVerificationData = emailVerificationData
        }
    }

    private func showLoginVC() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                let loginView = LoginViewController()
                window.rootViewController = loginView
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            try KeychainManager.shared.deleteToken(forKey: AUTH_TOKEN)

            showLoginVC()
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "登出帳號失敗")
        }
    }

    func updateUserEmailAddress(emailAddress: String, loadingVC: XOLoadingViewController) {
        Task {
            do {
                try await newApiManager.sendEmailVerification(emailAddress: emailAddress)
                await loadingVC.dismissVC()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "已發送驗證信，請前往信箱確認")
                }
            } catch let NewAPIManager.NewAPIManagerError.apiResponseError(code, _) {
                await loadingVC.dismissVC()
                var message = "寄發驗證信失敗"
                if code == 2005 {
                    message = "該郵件已被使用"
                } else if code == 2006 {
                    message = "以達到本日更改上限，請明天再更改"
                } else if code == 2007 {
                    message = "寄發驗證信失敗"
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    XOBottomBarInformationManager.showBottomInformation(type: .info, information: message)
                }
            } catch {
                await loadingVC.dismissVC()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    XOBottomBarInformationManager.showBottomInformation(type: .info, information: "以達到本日更改上限，請明天再更改")
                }
            }
        }
    }

    func deleteAccount() {
        Task {
            do {
                try await newApiManager.deleteUserInfo()
                await MainActor.run { showLoginVC() }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "刪除帳號失敗")
            }
        }
    }

    func refreshView() {
        startUpdate = false;
        Task {
            await getBasicInformation()
            await getUserInfo()
            await getAvatar()
            await getEmailVerification()
            await MainActor.run {
                controller?.settingTableView.reloadData()
                controller?.config()
                startUpdate = true
            }
        }
    }
}
