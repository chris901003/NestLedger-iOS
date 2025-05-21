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

    let apiManager = APIManager()
    let newApiManager = NewAPIManager()
    var userInfo = UserInfoData.initMock() {
        didSet {
            if !startUpdate { return }
            newSharedUserInfo = userInfo
            Task {
                try? await apiManager.updateUserInfo(userInfo)
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

    init() {
        Task {
            await getBasicInformation()
            await getUserInfo()
            await getAvatar()
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

    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "刪除帳號失敗")
            return
        }

        Task {
            do {
                try await apiManager.deleteAccount(uid: sharedUserInfo.id)
                try await user.delete()
                showLoginVC()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "刪除帳號失敗")
            }
        }
    }
}
