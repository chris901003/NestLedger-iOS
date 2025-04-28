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
        case failedGetLedgerInvite
        case failedDeleteLedgerInvite

        var errorDescription: String? {
            switch self {
                case .failedCreateLedgerInvite:
                    return "創建帳本邀請失敗"
                case .failedGetLedgerInvite:
                    return "獲取帳本邀請失敗"
                case .failedDeleteLedgerInvite:
                    return "刪除邀請失敗"
            }
        }
    }
}


// MARK: - Create Ledger Invite
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

// MARK: - Get Ledger Invites
extension APIManager {
    func getLedgerInvites(ledgerId: String?, receiveUserId: String?) async throws -> [LedgerInviteData] {
        if ledgerId == nil && receiveUserId == nil { throw APIManagerError.badUrl }
        guard var components = URLComponents(string: APIPath.LedgerInvite.get.getPath()) else { throw APIManagerError.badUrl }
        components.queryItems = []
        if let ledgerId { components.queryItems?.append(.init(name: "ledgerId", value: ledgerId)) }
        if let receiveUserId { components.queryItems?.append(.init(name: "receiveUserId", value: receiveUserId)) }

        guard let url = components.url else { throw APIManagerError.badUrl }
        let request = genRequest(url: url, method: .GET)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw LedgerInviteError.failedGetLedgerInvite }
            let ledgerInvites = try APIManager.decoder.decode(LedgerInvitesResponse.self, from: data)
            return ledgerInvites.data.ledgerInvites
        } catch {
            throw LedgerInviteError.failedGetLedgerInvite
        }
    }
}

// MARK: - Delete Ledger Invite
extension APIManager {
    enum DeleteLedgerInviteType: String {
        case acceptLedgerInvite = "同意邀請"
        case rejectLedgerInvite = "拒絕邀請"
        case retriveLedgerInvite = "收回邀請"

        func getAcceptValue() -> String {
            switch self {
                case .acceptLedgerInvite:
                    return "true"
                case .rejectLedgerInvite, .retriveLedgerInvite:
                    return "false"
            }
        }

        func getErrorType() -> DeleteLedgerInviteError {
            switch self {
                case .acceptLedgerInvite:
                    return .failedAccept
                case .rejectLedgerInvite:
                    return .failedReject
                case .retriveLedgerInvite:
                    return .failedRetrive
            }
        }
    }

    enum DeleteLedgerInviteError: LocalizedError {
        case failedAccept, failedReject, failedRetrive

        var errorDescription: String? {
            switch self {
                case .failedAccept:
                    return "同意邀請失敗"
                case .failedReject:
                    return "拒絕邀請失敗"
                case .failedRetrive:
                    return "收回邀請失敗"
            }
        }
    }

    @discardableResult
    func deleteLedgerInvite(ledgerInviteId: String, type: DeleteLedgerInviteType) async throws -> Bool {
        guard var components = URLComponents(string: APIPath.LedgerInvite.delete.getPath()) else { throw APIManagerError.badUrl }
        components.queryItems = [
            URLQueryItem(name: "ledgerInviteId", value: ledgerInviteId),
            URLQueryItem(name: "accept", value: type.getAcceptValue())
        ]

        guard let url = components.url else { throw APIManagerError.badUrl }
        let request = genRequest(url: url, method: .DELETE)
        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw type.getErrorType() }
            return true
        } catch {
            throw LedgerInviteError.failedDeleteLedgerInvite
        }
    }
}
