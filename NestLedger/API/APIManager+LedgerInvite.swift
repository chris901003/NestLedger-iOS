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
    fileprivate enum CreateLedgerInviteError: String, LocalizedError {
        case ledgerNotFound = "Ledger not found"
        case memberAlreadyExists = "Member already exists"
        case inviteAlreadyExists = "Invite already exists"

        var errorDescription: String? {
            switch self {
                case .ledgerNotFound:
                    return "帳目不存在"
                case .memberAlreadyExists:
                    return "該使用者已經在帳目成員當中"
                case .inviteAlreadyExists:
                    return "該使用者已經在邀請當中"
            }
        }
    }

    @discardableResult
    func createLedgerInvite(data: LedgerInviteData) async throws -> LedgerInviteData {
        guard let url = APIPath.LedgerInvite.create.getUrl(),
              let request = try? genRequest(url: url, method: .POST, body: data)else { throw APIManagerError.badUrl }
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse else { throw APIManagerError.badUrl }
            if response.statusCode == 200 {
                let ledgerInvite = try APIManager.decoder.decode(LedgerInviteResponse.self, from: data)
                return ledgerInvite.data.ledgerInvite
            } else {
                let failedResponse = try APIManager.decoder.decode(APIFailedResponseData.self, from: data)
                if let errorType = CreateLedgerInviteError(rawValue: failedResponse.message) {
                    throw errorType
                } else {
                    throw LedgerInviteError.failedCreateLedgerInvite
                }
            }
        } catch {
            if error is CreateLedgerInviteError {
                throw error
            } else {
                throw LedgerInviteError.failedCreateLedgerInvite
            }
        }
    }
}
