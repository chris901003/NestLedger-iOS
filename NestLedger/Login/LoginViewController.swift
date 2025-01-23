// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import AuthenticationServices
import xxooooxxCommonUI
import FirebaseAuth

class LoginViewController: XOLoginViewController {
    let manager = LoginVCManager()
    var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = manager
        manager.viewController = self
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            Task {
                let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
                await manager.loginWithThirdPartyAccount(credentail: credential)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) { }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
