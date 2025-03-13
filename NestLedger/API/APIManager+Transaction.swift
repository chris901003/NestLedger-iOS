// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

// MARK: - Transaction API
extension APIManager {
    enum TransactionError: LocalizedError {
        case failedCreateTransaction

        var errorDescription: String? {
            switch self {
                case .failedCreateTransaction:
                    return "創建帳目失敗"
            }
        }
    }
}

extension APIManager {
    func createTransaction(data: TransactionData) async throws -> TransactionData {
        guard let url = APIPath.Transaction.create.getUrl() else { throw APIManagerError.badUrl }
        let dateFormatter = ISO8601DateFormatter()
        let parameters: [String: Any] = [
            "title": data.title,
            "note": data.note,
            "money": data.money,
            "date": dateFormatter.string(from: data.date),
            "type": data.type.rawValue,
            "userId": data.userId,
            "tagId": data.tagId,
            "ledgerId": data.ledgerId,
            "version": data.version
        ]
        let request = genRequest(url: url, method: .POST, body: parameters)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw TransactionError.failedCreateTransaction
            }

            let transactionData = try APIManager.decoder.decode(TransactionResponse.self, from: data)
            return transactionData.data.transaction
        } catch {
            throw TransactionError.failedCreateTransaction
        }
    }
}
