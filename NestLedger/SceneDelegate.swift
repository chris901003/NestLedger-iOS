// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/23.
// Copyright © 2025 HongYan. All rights reserved.


import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let newApiManager = NewAPIManager()

        if let user = Auth.auth().currentUser,
           let lastToken = KeychainManager.shared.getToken(forKey: AUTH_TOKEN) {
            print("✅ 已登入: \(user.uid)")
            NewAPIManager.authToken = lastToken
            Task {
                do {
                    try await FirebaseAuthManager.shared.refreshTokenIfNeeded()
                    try await newApiManager.login()
                    updateAppVersionAnalysis()
                    let rootViewController = RootViewController()
                    window?.rootViewController = rootViewController
                } catch {
                    await MainActor.run {
                        let loginVC = LoginViewController()
                        window?.rootViewController = loginVC
                    }
                }
            }
        } else {
            print("✅ 尚未登入")
            let loginVC = LoginViewController()
            window?.rootViewController = loginVC
        }
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }

        let parts = url.pathComponents
        guard let resource = parts.dropFirst().first,
              let action = parts.dropFirst().dropFirst().first else { return }
        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        switch url.path() {
            case LEDGER_INVITE_LINK_URL:
                guard let token = comps?.queryItems?.first(where: { $0.name == "token" })?.value,
                      let ledgerId = comps?.queryItems?.first(where: { $0.name == "ledgerId" })?.value else { return }
                let ledgerLinkJoinVC = LedgerLinkJoinViewController(token: token, ledgerId: ledgerId)
                ledgerLinkJoinVC.modalPresentationStyle = .overFullScreen
                ledgerLinkJoinVC.modalTransitionStyle = .crossDissolve
                guard let rootVC = UIApplicationUtility.getTopViewController() else { return }
                rootVC.present(ledgerLinkJoinVC, animated: true)
            case LEDGER_SPLIT_INVITE_LINK_URL:
                guard let token = comps?.queryItems?.first(where: { $0.name == "token" })?.value,
                      let ledgerSplitId = comps?.queryItems?.first(where: { $0.name == "ledgerSplitId" })?.value else { return }
                let ledgerSplitJoinVC = LedgerSplitJoinViewController(ledgerSplitId: ledgerSplitId, token: token)
                ledgerSplitJoinVC.modalPresentationStyle = .overFullScreen
                ledgerSplitJoinVC.modalTransitionStyle = .crossDissolve
                guard let rootVC = UIApplicationUtility.getTopViewController() else { return }
                rootVC.present(ledgerSplitJoinVC, animated: true)
            default:
                break
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) {
        updateAppVersionAnalysis()
    }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

