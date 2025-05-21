// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum InformationError: LocalizedError {
        case decodeBasicInformationFailed

        var errorDescription: String? {
            switch self {
                case .decodeBasicInformationFailed:
                    return "Decode basic information failed."
            }
        }
    }
}

extension NewAPIManager {
    func getBasicInformation() async throws -> BasicInformationData {
        let responseData = await session.request(NewAPIPath.Information.basic.getPath(), method: .get)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            let information = try NewAPIManager.decoder.decode(BasicInformationResponse.self, from: data)
            return information.data
        } catch {
            throw InformationError.decodeBasicInformationFailed
        }
    }
}
