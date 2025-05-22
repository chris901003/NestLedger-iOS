// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum TransactionError: LocalizedError {
        case decodeTransactionFailed

        var errorDescription: String? {
            switch self {
                case .decodeTransactionFailed:
                    return "解析帳目失敗"
            }
        }
    }
}

// MARK: - Create Transaction
extension NewAPIManager {
    func createTransaction(data: TransactionCreateRequestData) async throws -> TransactionData {
        let responseData = await session.request(
            NewAPIPath.Transaction.create.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder(encoder: NewAPIManager.encoder))
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanTransactionResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw TransactionError.decodeTransactionFailed
        }
    }
}

// MARK: - Query Transaction
extension NewAPIManager {
    func queryTransaction(data: TransactionQueryRequestData) async throws -> [TransactionData] {
        let responseData = await session.request(
            NewAPIPath.Transaction.query.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder(encoder: NewAPIManager.encoder))
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanTransactionsResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw TransactionError.decodeTransactionFailed
        }
    }
}
