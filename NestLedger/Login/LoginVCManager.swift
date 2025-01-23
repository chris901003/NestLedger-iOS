// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI
import xxooooxxCommonFunction
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices

class LoginVCManager {
    weak var viewController: LoginViewController?

    @MainActor
    private func loginWithApple() async {
        guard let viewController else { return }
        viewController.currentNonce = AppleLoginFlow.startSignWithAppleFlow(delegate: viewController, presentation: viewController)
    }

    @MainActor
    private func loginWithGoogle() async {
        guard let topVC = UIViewController.getTopViewController() else { return }

        do {
            let gidSignResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            guard let idToken = gidSignResult.user.idToken?.tokenString else { return }
            let accessToken = gidSignResult.user.accessToken.tokenString
            let credentail = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            await loginWithThirdPartyAccount(credentail: credentail)
        } catch {
            print("✅ [LVCM] Login with google error: \(error.localizedDescription)")
        }
    }

    func loginWithThirdPartyAccount(credentail: AuthCredential) async {
        do {
            let authDataResult = try await Auth.auth().signIn(with: credentail)
            let authToken = try await authDataResult.user.getIDToken()
            // TODO: 將這個獲得的 auth token 拿去存起來
            print("✅ Auth Token: \(authToken)")
        } catch {
            print("✅ [LVCM] Login with credentail error: \(error.localizedDescription)")
        }
    }
}

// MARK: - XOLoginViewControllerDelegate
extension LoginVCManager: XOLoginViewControllerDelegate {
    func appleSignInAction() {
        Task { await loginWithApple() }
    }

    func googleSignInAction() {
        Task { await loginWithGoogle() }
    }
}
