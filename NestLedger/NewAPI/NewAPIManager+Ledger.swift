// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum LedgerError: LocalizedError {
        case decodeLedgerDataFailed

        var localizedDescription: String {
            switch self {
                case .decodeLedgerDataFailed:
                    return "解析帳本失敗"
            }
        }
    }
}

// MARK: - Get Ledger
extension NewAPIManager {
    func getLedger(ledgerId: String) async throws -> LedgerData {
        let responseData = await session.request(
            NewAPIPath.Ledger.get.getPath(),
            method: .get,
            parameters: ["ledgerId": ledgerId])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerError.decodeLedgerDataFailed
        }
    }
}

// MARK: - Create Ledger
extension NewAPIManager {
    func createLedger(data: LedgerCreateRequestData) async throws -> LedgerData {
        let responseData = await session.request(
            NewAPIPath.Ledger.create.getPath(),
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerError.decodeLedgerDataFailed
        }
    }
}

// MARK: - Update Ledger
extension NewAPIManager {
    func updateLedger(data: LedgerUpdateRequestData) async throws -> LedgerData {
        let responseData = await session.request(
            NewAPIPath.Ledger.update.getPath(),
            method: .patch,
            parameters: data,
            encoder: JSONParameterEncoder.default)
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(CleanLedgerDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerError.decodeLedgerDataFailed
        }
    }
}

// MARK: - Leave Ledger
extension NewAPIManager {
    func leaveLedger(uid: String, ledgerId: String) async throws -> LedgerData? {
        let responseData = await session.request(
            NewAPIPath.Ledger.leave.getPath(),
            method: .get,
            parameters: ["uid": uid, "ledgerId": ledgerId])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(OptionalLedgerDataResponse.self, from: data).data
        } catch {
            if error is NewAPIManagerError { throw error }
            throw LedgerError.decodeLedgerDataFailed
        }
    }
}
