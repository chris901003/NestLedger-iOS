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
    var userInfo = UserInfoData.initMock() {
        didSet {
            if !startUpdate { return }
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
                    let path = try await apiManager.uploadSinglePhoto(image, path: "avatar")
                    userInfo.avatar = path
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "更新頭像失敗")
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
            let response = try await apiManager.getBasicInformation()
            basicInformation = response.data
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .info, information: "無法取得最新資訊")
        }
    }

    private func getUserInfo() async {
        do {
            userInfo = try await apiManager.getUserInfo()
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取得帳號資訊")
        }
    }

    private func getAvatar() async {
        guard !userInfo.avatar.isEmpty else { return }
        do {
            let image = try await apiManager.fetchSinglePhoto(path: userInfo.avatar)
            avatar = image
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法取的頭像")
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            try KeychainManager.shared.deleteToken(forKey: AUTH_TOKEN)

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                let loginView = LoginViewController()
                window.rootViewController = loginView
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        } catch {
            XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "登出帳號失敗")
        }
    }
}
