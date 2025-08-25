// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum LedgerInviteError: LocalizedError {
        case decodeLedgerInviteFailed

        var localizedDescription: String {
            switch self {
                case .decodeLedgerInviteFailed:
                    return "解析邀請信息失敗"
            }
        }
    }
}

// MARK: - Get Ledger Invite
extension NewAPIManager {
    func getLedgerInvite(ledgerId: String?, receiveUserId: String?) async throws -> [LedgerInviteData] {
        var params: [String: String] = [:]
        if let ledgerId = ledgerId { params["ledgerId"] = ledgerId }
        if let receiveUserId = receiveUserId { params["receiveUserId"] = receiveUserId }
        let responseData = await session.request(
            NewAPIPath.LedgerInvite.get.getPath(),
            method: .get,
            parameters: params)
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerInvitesResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerInviteError.decodeLedgerInviteFailed
        }
    }
}

// MARK: - Create Ledger Invite
extension NewAPIManager {
    func createLedgerInvite(data: LedgerInviteCreateRequestData) async throws -> LedgerInviteData {
        let responseData = await session.request(
            NewAPIPath.LedgerInvite.create.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerInviteResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerInviteError.decodeLedgerInviteFailed
        }
    }
}

// MARK: - Delete Ledger Invite
extension NewAPIManager {
    func deleteLedgerInvite(inviteId: String, accept: Bool) async throws {
        let responseData = await session.request(
            NewAPIPath.LedgerInvite.delete.getPath(),
            method: .delete,
            parameters: ["inviteId": inviteId, "accept": accept ? "true" : "false"])
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
    }
}

// MARK: - Create Ledger Invite Link
extension NewAPIManager {
    func createLedgerInviteLink(ledgerId: String) async throws -> LedgerQRCodeInviteData {
        let params: [String: String] = ["ledgerId": ledgerId]
        let responseData = await session.request(
            NewAPIPath.LedgerInvite.createLink.getPath(),
            method: .get,
            parameters: params)
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(LedgerQRCodeInviteDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerInviteError.decodeLedgerInviteFailed
        }
    }
}

// MARK: - Ledger Link Invite
extension NewAPIManager {
    func ledgerLinkInvite(token: String) async throws -> UserInfoData {
        let responseData = await session.request(
            NewAPIPath.LedgerInvite.ledgerLinkInvite.getPath(),
            method: .get,
            parameters: ["token": token])
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanUserInforesponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw UserInfoError.decodeUserInfoError
        }
    }
}
