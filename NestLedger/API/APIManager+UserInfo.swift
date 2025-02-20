// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

// MARK: - UserInfo API
extension APIManager {
    enum UserInfoError: LocalizedError {
        case failedLogin, failedFetchUserInfo

        var errorDescription: String? {
            switch self {
                case .failedLogin:
                    return "登入失敗"
                case .failedFetchUserInfo:
                    return "獲取使用者資料失敗"
            }
        }
    }

    func login() async throws {
        guard let url = APIPath.UserInfo.login.getUrl() else { return }
        let request = genGetRequest(url: url)

        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw UserInfoError.failedLogin
            }
        } catch {
            throw UserInfoError.failedLogin
        }
    }

    func getUserInfo() async throws {
        guard let url = APIPath.UserInfo.userInfo.getUrl() else { return }
        let request = genGetRequest(url: url)

        do {
            let (data, response) = try await send(request: request)
            print("✅ Data: \(data)")
        } catch {
            throw UserInfoError.failedFetchUserInfo
        }
    }
}
