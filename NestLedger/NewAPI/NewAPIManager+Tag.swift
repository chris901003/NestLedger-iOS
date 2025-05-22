// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum TagError: LocalizedError {
        case failedDecodeTagData
        case failedUpdateTag

        var localizedDescription: String {
            switch self {
                case .failedDecodeTagData:
                    return "無法解析標籤資訊"
                case .failedUpdateTag:
                    return "更新標籤失敗"
            }
        }
    }
}

// MARK: - Create Tag
extension NewAPIManager {
    func createTag(data: TagCreateRequestData) async throws -> TagData {
        let responseData = await session.request(
            NewAPIPath.Tag.create.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanTagDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw TagError.failedDecodeTagData
        }
    }
}

// MARK: - Query Tag
extension NewAPIManager {
    func queryTag(data: TagQueryRequestData) async throws -> [TagData] {
        let responseData = await session.request(
            NewAPIPath.Tag.query.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanTagsDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw TagError.failedDecodeTagData
        }
    }
}

// MARK: - Update Tag
extension NewAPIManager {
    func updateTag(data: TagUpdateRequestData) async throws -> TagData {
        let responseData = await session.request(
            NewAPIPath.Tag.update.getPath(),
            method: .patch,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanTagDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw TagError.failedUpdateTag
        }
    }
}

// MARK: - Delete Tag
extension NewAPIManager {
    func deleteTag(tagId: String) async throws {
        let responseData = await session.request(NewAPIPath.Tag.delete.getPath(), method: .delete, parameters: ["tagId": tagId])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
    }
}
