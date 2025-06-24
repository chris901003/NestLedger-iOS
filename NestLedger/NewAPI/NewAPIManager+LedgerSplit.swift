// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum LedgerSplitError: LocalizedError {
        case decodeLedgerSplitDataFaield

        var localizedDescription: String {
            switch self {
                case .decodeLedgerSplitDataFaield:
                    return "解析分帳本失敗"
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
