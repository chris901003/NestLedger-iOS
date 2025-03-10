// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

// MARK: - Ledger API
extension APIManager {
    enum LedgerError: LocalizedError {
        case failedCreateLedger

        var errorDescription: String? {
            switch self {
                case .failedCreateLedger:
                    return "創建新帳本失敗"
            }
        }
    }
}

extension APIManager {
    func createLedger(title: String, version: Int) async throws -> LedgerData {
        guard let url = APIPath.Ledger.create.getUrl() else { throw APIManagerError.badUrl }
        let parameters: [String: Any] = [
            "title": title,
            "version": version
        ]
        let request = genRequest(url: url, method: .POST, body: parameters)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw LedgerError.failedCreateLedger
            }
            let result = try APIManager.decoder.decode(LedgerDataResponse.self, from: data)
            return result.data.ledger
        } catch {
            throw LedgerError.failedCreateLedger
        }
    }
}
