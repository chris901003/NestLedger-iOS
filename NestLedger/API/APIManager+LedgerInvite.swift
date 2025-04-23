// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension APIManager {
    enum LedgerInviteError: LocalizedError {
        case failedCreateLedgerInvite

        var errorDescription: String? {
            switch self {
                case .failedCreateLedgerInvite:
                    return "創建帳本邀請失敗"
            }
        }
    }
}

extension APIManager {
    @discardableResult
    func createLedgerInvite(data: LedgerInviteData) async throws -> LedgerInviteData {
        guard let url = APIPath.LedgerInvite.create.getUrl(),
              let request = try? genRequest(url: url, method: .POST, body: data)else { throw APIManagerError.badUrl }
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw LedgerInviteError.failedCreateLedgerInvite }
            let ledgerInvite = try APIManager.decoder.decode(LedgerInviteResponse.self, from: data)
            return ledgerInvite.data.ledgerInvite
        } catch {
            throw LedgerInviteError.failedCreateLedgerInvite
        }
    }
}
