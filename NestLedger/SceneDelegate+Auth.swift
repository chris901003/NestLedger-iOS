// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import FirebaseAuth

extension SceneDelegate {
    func refreshTokenAndCheckIfValid(user: User) async throws {
        let token = try await user.getIDToken(forcingRefresh: true)
        try KeychainManager.shared.saveToken(token, forKey: AUTH_TOKEN)
        APIManager.authToken = token
    }
}
