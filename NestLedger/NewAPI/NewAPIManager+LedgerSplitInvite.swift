// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum LedgerSplitInviteError: LocalizedError {
        case decodeLedgerSplitInviteFailed

        var localizedDescription: String {
            switch self {
                case .decodeLedgerSplitInviteFailed:
                    return "解析邀請信息失敗"
            }
        }
    }
}

// MARK: - Ledger Split Invite Create Link
extension NewAPIManager {
    func ledgerSplitInviteCreateLink(ledgerSplitId: String) async throws -> LedgerSplitQRCodeInviteData {
        let responseData = await session.request(
            NewAPIPath.LedgerSplitInvite.createLink.getPath(),
            method: .get,
            parameters: ["ledgerSplitId": ledgerSplitId])
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(LedgerSplitQRCodeInviteDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerSplitInviteError.decodeLedgerSplitInviteFailed
        }
    }
}

// MARK: - Ledger Split Link Invite
extension NewAPIManager {
    func ledgerSplitLinkInvite(token: String) async throws -> UserInfoData {
        let responseData = await session.request(
            NewAPIPath.LedgerSplitInvite.linkInvite.getPath(),
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
            throw LedgerSplitInviteError.decodeLedgerSplitInviteFailed
        }
    }
}
