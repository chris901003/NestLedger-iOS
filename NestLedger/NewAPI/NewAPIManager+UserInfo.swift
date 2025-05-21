// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum UserInfoError: LocalizedError {
        case decodeUserInfoError

        var localizedDescription: String {
            switch self {
                case .decodeUserInfoError:
                    return "Decode user info error."
            }
        }
    }
}

// MARK: - Login
extension NewAPIManager {
    func login() async throws {
        let responseData = await session.request(NewAPIPath.UserInfo.login.getPath(), method: .get)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            let userInfo = try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data)
            newSharedUserInfo = userInfo.data
        } catch {
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Get User Info
extension NewAPIManager {
    func getUserInfo() async throws -> UserInfoData {
        let responseData = await session.request(NewAPIPath.UserInfo.get.getPath(), method: .get)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            throw UserInfoError.decodeUserInfoError
        }
    }
}
