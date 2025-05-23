// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire
import UIKit

extension NewAPIManager {
    enum UserInfoError: LocalizedError {
        case decodeUserInfoError
        case convertUIImageToDataError
        case decodeDataToUIImageError

        var localizedDescription: String {
            switch self {
                case .decodeUserInfoError:
                    return "Decode user info error."
                case .convertUIImageToDataError:
                    return "Convert UIImage to Data error."
                case .decodeDataToUIImageError:
                    return "Decode Data to UIImage error."
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
            if error is NewAPIManagerError { throw error }
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
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Get User Info By Uid
extension NewAPIManager {
    func getUserInfoByUid(uid: String) async throws -> UserInfoData {
        let responseData = await session.request(NewAPIPath.UserInfo.getUserById.getPath(), method: .get, parameters: ["uid": uid])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Get Multiple User Info
extension NewAPIManager {
    func getMultipleUserInfo(uids: [String]) async throws -> [UserInfoData] {
        let responseData = await session.request(
            NewAPIPath.UserInfo.getMultipleUserInfo.getPath(),
            method: .post,
            parameters: ["uids": uids],
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInfosResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Get User By Email
extension NewAPIManager {
    func getUserByEmail(emailAddress: String) async throws -> UserInfoData {
        let responseData = await session.request(
            NewAPIPath.UserInfo.getUserByEmail.getPath(),
            method: .get,
            parameters: ["email": emailAddress])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Get User Avatar
extension NewAPIManager {
    func getUserAvatar(uid: String) async throws -> UIImage {
        let response = await session.request(NewAPIPath.UserInfo.avatar.getPath(), method: .get, parameters: ["uid": uid])
            .serializingData()
            .response
        try checkResponse(responseData: response)
        guard let data = response.data else { throw NewAPIManagerError.responseDataNotFound }
        guard let image = UIImage(data: data) else { throw UserInfoError.decodeDataToUIImageError }
        return image
    }
}

// MARK: - Upload User Avatar
extension NewAPIManager {
    func uploadUserAvatar(image: UIImage) async throws -> UserInfoData {
        guard let imageData = image.jpegData(compressionQuality: newSharedUserInfo.imageQuality) else {
            throw UserInfoError.convertUIImageToDataError
        }

        let response = await session.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
            },
            to: NewAPIPath.UserInfo.uploadAvatar.getPath(),
            method: .post)
            .serializingData()
            .response
        try checkResponse(responseData: response)
        do {
            guard let data = response.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Update User Info
extension NewAPIManager {
    func updateUserInfo(requestData: UserInfoUpdateRequestData) async throws -> UserInfoData {
        let response = await session.request(
            NewAPIPath.UserInfo.update.getPath(),
            method: .patch,
            parameters: requestData,
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: response)
        do {
            guard let data = response.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}

// MARK: - Change Quick Log Ledger
extension NewAPIManager {
    func changeQuickLogLedger(ledgerId: String) async throws -> UserInfoData {
        let responseData = await session.request(
            NewAPIPath.UserInfo.changeQuickLogLedger.getPath(),
            method: .patch,
            parameters: ["ledgerId": ledgerId])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
            
    }
}

// MARK: - Delete User Info
extension NewAPIManager {
    func deleteUserInfo() async throws {
        let response = await session.request(NewAPIPath.UserInfo.delete.getPath(), method: .delete)
            .serializingData()
            .response
        try checkResponse(responseData: response)
    }
}
