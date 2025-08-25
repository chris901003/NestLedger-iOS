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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
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
                guard let token = comps?.queryItems?.first(where: { $0.name == "token" })?.value else { return }
                let ledgerLinkJoinVC = LedgerLinkJoinViewController(token: token)
                ledgerLinkJoinVC.modalPresentationStyle = .overFullScreen
                ledgerLinkJoinVC.modalTransitionStyle = .crossDissolve
                guard let rootVC = UIApplicationUtility.getTopViewController() else { return }
                rootVC.present(ledgerLinkJoinVC, animated: true)
            default:
                break
        }
        switch (resource, action) {
            case ("ledger-split", "invite"):
                let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
                guard let ledgerSplitId = comps?.queryItems?.first(where: { $0.name == "ledgerSplitId" })?.value else { return }
                let ledgerSplitJoinVC = LedgerSplitJoinViewController(ledgerSplitId: ledgerSplitId)
                let window = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
                guard let viewController = window?.rootViewController else { return }
                ledgerSplitJoinVC.modalPresentationStyle = .overFullScreen
                ledgerSplitJoinVC.modalTransitionStyle = .crossDissolve
                viewController.present(ledgerSplitJoinVC, animated: true)
            default:
                break
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

