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
        case failedRemoveLedgerMember

        var errorDescription: String? {
            switch self {
                case .failedCreateLedger:
                    return "創建新帳本失敗"
                case .failedGetLedger:
                    return "獲取帳本失敗"
                case . failedRemoveLedgerMember:
                    return "刪除帳本成員失敗"
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
            return result.data.Ledger
        } catch {
            throw LedgerError.failedCreateLedger
        }
    }

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
