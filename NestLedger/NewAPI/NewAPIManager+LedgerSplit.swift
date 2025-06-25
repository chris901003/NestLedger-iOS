// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire
import UIKit

extension NewAPIManager {
    enum LedgerSplitError: LocalizedError {
        case decodeLedgerSplitDataFaield
        case convertAvatarFaield
        case decodeToUIImageError

        var localizedDescription: String {
            switch self {
                case .decodeLedgerSplitDataFaield:
                    return "解析分帳本失敗"
                case .convertAvatarFaield:
                    return "轉換照片失敗"
                case .decodeToUIImageError:
                    return "轉換圖像失敗"
            }
        }
    }
}

// MARK: - Create Ledger Split
extension NewAPIManager {
    func createLedgerSplit(data: LedgerSplitCreateRequestData) async throws -> LedgerSplitData {
        let responseData = await session.request(
            NewAPIPath.LedgerSplit.create.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerSplitDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerSplitError.decodeLedgerSplitDataFaield
        }
    }
}

// MARK: - Upload Ledger Split Avatar
extension NewAPIManager {
    func uploadLedgerSplitAvatar(ledgerSplitId: String, avatar: UIImage) async throws {
        guard let imageData = avatar.jpegData(compressionQuality: newSharedUserInfo.imageQuality) else {
            throw LedgerSplitError.convertAvatarFaield
        }

        let response = await session.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
                if let ledgerSplitId = ledgerSplitId.data(using: .utf8) {
                    multipartFormData.append(ledgerSplitId, withName: "ledgerSplitId")
                }
            },
            to: NewAPIPath.LedgerSplit.uploadAvatar.getPath(),
            method: .post)
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: response)
    }
}

// MARK: - Get Ledger Split
extension NewAPIManager {
    func getLedgerSplitData(ledgerSplitId: String) async throws -> LedgerSplitData {
        let responseData = await session.request(
            NewAPIPath.LedgerSplit.get.getPath(),
            method: .get,
            parameters: ["ledgerSplitId": ledgerSplitId])
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerSplitDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerSplitError.decodeLedgerSplitDataFaield
        }
    }
}

// MARK: - Get Ledger Split Avatar
extension NewAPIManager {
    func getLedgerSplitAvatar(ledgerSplitId: String) async throws -> UIImage {
        let responseData = await session.request(
            NewAPIPath.LedgerSplit.avatar.getPath(),
            method: .get,
            parameters: ["ledgerSplitId": ledgerSplitId])
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
        guard let image = UIImage(data: data) else { throw LedgerSplitError.decodeToUIImageError }
        return image
    }
}
