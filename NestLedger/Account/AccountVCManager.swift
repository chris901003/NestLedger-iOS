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
            Task {
                try? await apiManager.updateUserInfo(userInfo)
                await MainActor.run {
                    XOBottomBarInformationManager.showBottomInformation(type: .success,information: "資料已更新")
                }
            }
        }
    }
    var avatar: UIImage?
    var basicInformation = BasicInformationData()

    init() {
        Task {
            await getBasicInformation()
            await getUserInfo()
            await MainActor.run {
                controller?.settingTableView.reloadData()
                controller?.config()
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
