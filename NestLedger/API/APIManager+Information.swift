// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    enum InformationError: LocalizedError {
        case failedGetUrl
        case failedGetBasicInformation

        var errorDescription: String? {
            switch self {
                case .failedGetUrl:
                    return "獲取 URL 失敗"
                case .failedGetBasicInformation:
                    return "取得基礎資訊失敗"
            }
        }
    }

    func getBasicInformation() async throws -> BasicInformationResponse {
        guard let url = APIPath.Information.basic.getUrl() else { throw InformationError.failedGetUrl }
        let request = genGetRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw InformationError.failedGetBasicInformation }
            let result = try APIManager.decoder.decode(BasicInformationResponse.self, from: data)
            return result
        } catch {
            throw InformationError.failedGetBasicInformation
        }
    }
}
