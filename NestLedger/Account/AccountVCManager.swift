// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import FirebaseAuth
import UIKit

class AccountVCManager {
    let apiManager = APIManager()
    var userInfo = UserInfoData.init(userName: "xxooooxx", emailAddress: "service@xxooooxx.org", avatar: nil, timeZone: 8) {
        didSet {
            print("✅ Update user info")
        }
    }

    init() {
        Task {
            await getUserInfo()
        }
    }

    private func getUserInfo() async {
        do {
            try await apiManager.getUserInfo()
        } catch {
            print("✅ Error: \(error.localizedDescription)")
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
            print("✅ [AVCM] Logout failed: \(error.localizedDescription)")
        }
    }
}
