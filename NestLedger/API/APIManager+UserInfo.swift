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
        case failedLogin, failedFetchUserInfo, failedEncode, failedUpdateUserInfo

        var errorDescription: String? {
            switch self {
                case .failedLogin:
                    return "登入失敗"
                case .failedFetchUserInfo:
                    return "獲取使用者資料失敗"
                case .failedEncode:
                    return "Encode 使用者資料失敗"
                case .failedUpdateUserInfo:
                    return "更新使用者資訊失敗"
            }
        }
    }

    func login() async throws {
        guard let url = APIPath.UserInfo.login.getUrl() else { return }
        let request = genRequest(url: url, method: .GET)

        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw UserInfoError.failedLogin
            }
            
            // Create main ledger if needed
            var userInfo = try await getUserInfo()
            if userInfo.ledgerIds.isEmpty {
                let ledger = try await createLedger(title: "[Main]:\(userInfo.id)", version: LEDGER_DATA_VERSION)
                userInfo.ledgerIds.append(ledger._id)
                try await updateUserInfo(userInfo)
            }
        } catch {
            throw UserInfoError.failedLogin
        }
    }

    func getUserInfo() async throws -> UserInfoData {
        guard let url = APIPath.UserInfo.userInfo.getUrl() else { throw APIManagerError.badUrl }
        let request = genRequest(url: url, method: .GET)

        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw UserInfoError.failedFetchUserInfo }
            let result = try APIManager.decoder.decode(UserInfoResponse.self, from: data)
            return result.data.UserInfo
        } catch {
            throw UserInfoError.failedFetchUserInfo
        }
    }

    func updateUserInfo(_ data: UserInfoData) async throws {
        guard let url = APIPath.UserInfo.update.getUrl() else { throw APIManagerError.badUrl }
        var request = genRequest(url: url, method: .PATCH)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let requestBody = try JSONEncoder().encode(data)
            request.httpBody = requestBody
        } catch {
            throw UserInfoError.failedEncode
        }

        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw UserInfoError.failedUpdateUserInfo
            }
        } catch {
            throw UserInfoError.failedUpdateUserInfo
        }
    }
}
