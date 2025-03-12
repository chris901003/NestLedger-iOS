// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

// MARK: - Tag API
extension APIManager {
    enum TagError: LocalizedError {
        case failedCreateTag
        case failedGetTag

        var errorDescription: String? {
            switch self {
                case .failedCreateTag:
                    return "創建標籤失敗"
                case .failedGetTag:
                    return "獲取標籤失敗"
            }
        }
    }
}

extension APIManager {
    func createTag(data: TagData) async throws -> TagData {
        guard let url = APIPath.Tag.create.getUrl() else { throw APIManagerError.badUrl }
        let parameters: [String: Any] = [
            "label": data.label,
            "color": data.color,
            "ledgerId": data.ledgerId,
            "version": data.version
        ]
        let request = genRequest(url: url, method: .POST, body: parameters)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw TagError.failedCreateTag
            }
            let tagData = try APIManager.decoder.decode(TagDataResponse.self, from: data)
            return tagData.data.Tag
        } catch {
            throw TagError.failedCreateTag
        }
    }

    func getTagsBy(ledgerId: String, search: String? = nil, page: Int? = nil, limit: Int? = nil) async throws -> [TagData] {
        guard var components = URLComponents(string: APIPath.Tag.getByLedger.getPath()) else { throw APIManagerError.badUrl }
        components.queryItems = [URLQueryItem(name: "ledgerId", value: ledgerId)]
        if let search { components.queryItems?.append(.init(name: "search", value: search)) }
        if let page { components.queryItems?.append(.init(name: "page", value: "\(page)")) }
        if let limit { components.queryItems?.append(.init(name: "limit", value: "\(limit)")) }

        guard let url = components.url else { throw APIManagerError.badUrl }
        let request = genRequest(url: url, method: .GET)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw TagError.failedGetTag }
            let result = try APIManager.decoder.decode(TagsDataResponse.self, from: data)
            return result.data.tags
        } catch {
            throw TagError.failedGetTag
        }
    }
}
