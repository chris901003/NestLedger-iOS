// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import FirebaseAuth

enum FirebaseAuthManagerError: LocalizedError {
    case notLogin
}

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()

    private init() { }

    func refreshTokenIfNeeded() async throws {
        guard let user = Auth.auth().currentUser else {
            throw FirebaseAuthManagerError.notLogin
        }

        if let tokenResult = try? await user.getIDTokenResult() {
            // getIDTokenResult() possibly refreshing it if it has expired (by Firebase)
            try KeychainManager.shared.saveToken(tokenResult.token, forKey: AUTH_TOKEN)
            NewAPIManager.authToken = tokenResult.token
            print("✅ Token: \(tokenResult.token)")
            return
        }
        try await refreshToken()
    }

    func refreshToken() async throws {
        guard let user = Auth.auth().currentUser else { return }
        let token = try await user.getIDToken(forcingRefresh: true)
        try KeychainManager.shared.saveToken(token, forKey: AUTH_TOKEN)
        NewAPIManager.authToken = token
    }
}
