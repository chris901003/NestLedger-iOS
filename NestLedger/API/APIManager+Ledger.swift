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
        case failedGetLedger
        case failedUpdateLedger
        case failedRemoveLedgerMember

        var errorDescription: String? {
            switch self {
                case .failedCreateLedger:
                    return "創建新帳本失敗"
                case .failedGetLedger:
                    return "獲取帳本失敗"
                case .failedUpdateLedger:
                    return "更新帳本失敗"
                case . failedRemoveLedgerMember:
                    return "刪除帳本成員失敗"
            }
        }
    }
}

// MARK: - Create Ledger
extension APIManager {
    fileprivate struct CreateLedgerData: Encodable {
        let title: String
        let version: Int = LEDGER_DATA_VERSION
    }

    func createLedger(title: String) async throws -> LedgerData {
        guard let url = APIPath.Ledger.create.getUrl() else { throw APIManagerError.badUrl }
        let body = CreateLedgerData(title: title)
        guard let request = try? genRequest(url: url, method: .POST, body: body) else { throw APIManagerError.badUrl }
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw LedgerError.failedCreateLedger
            }
            let result = try APIManager.decoder.decode(LedgerDataResponse.self, from: data)
            return result.data.Ledger
        } catch {
            throw LedgerError.failedCreateLedger
        }
    }
}

extension APIManager {

    func getLedger(ledgerId: String) async throws -> LedgerData {
        guard var component = URLComponents(string: APIPath.Ledger.get.getPath()) else { throw APIManagerError.badUrl }
        component.queryItems = [URLQueryItem(name: "ledgerId", value: ledgerId)]

        guard let url = component.url else { throw APIManagerError.badUrl }
        let request = genRequest(url: url, method: .GET)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw LedgerError.failedGetLedger }
            let result = try APIManager.decoder.decode(LedgerDataResponse.self, from: data)
            return result.data.Ledger
        } catch {
            throw LedgerError.failedGetLedger
        }
    }
}

// MARK: - Update Ledger Data
extension APIManager {
    fileprivate struct UpdateLedgerData: Codable {
        let ledgerId: String
        let ledger: LedgerData
    }

    func updateLedger(ledgerData: LedgerData) async throws {
        guard let url = APIPath.Ledger.update.getUrl() else { throw APIManagerError.badUrl }
        let body = UpdateLedgerData(ledgerId: ledgerData._id, ledger: ledgerData)
        guard let request = try? genRequest(url: url, method: .PATCH, body: body) else { throw APIManagerError.badUrl }
        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw LedgerError.failedUpdateLedger }
            return
        } catch {
            throw LedgerError.failedUpdateLedger
        }
    }
}

extension APIManager {
    @discardableResult
    func deleteLedgerMember(ledgerId: String, userId: String) async throws -> LedgerData {
        guard var component = URLComponents(string: APIPath.Ledger.deleteLedgerMember.getPath()) else { throw APIManagerError.badUrl }
        component.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "ledgerId", value: ledgerId)
        ]

        guard let url = component.url else { throw APIManagerError.badUrl }
        let request = genRequest(url: url, method: .DELETE)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw LedgerError.failedRemoveLedgerMember }
            let result = try APIManager.decoder.decode(LedgerDataResponse.self, from: data)
            return result.data.Ledger
        } catch {
            throw LedgerError.failedRemoveLedgerMember
        }
    }
}
