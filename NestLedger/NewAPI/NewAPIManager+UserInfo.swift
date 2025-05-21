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
