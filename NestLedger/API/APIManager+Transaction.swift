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
        case failedGetTransaction

        var errorDescription: String? {
            switch self {
                case .failedCreateTransaction:
                    return "創建帳目失敗"
                case .failedGetTransaction:
                    return "獲取帳目失敗"
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

extension Int? {
    func toString() -> String? {
        self == nil ? nil : "\(self!)"
    }
}

extension APIManager {
    struct TransactionGetByLedgerQuery {
        let ledgerId: String
        let page: Int?
        let limit: Int?
        let search: String?
        let startDate: Date?
        let endDate: Date?
        let tagId: String?
        let type: TransactionType?
        let userId: String?
        let sortedOrder: APIManager.SortedOrderType?

        init(
            ledgerId: String,
            page: Int? = nil,
            limit: Int? = nil,
            search: String? = nil,
            startDate: Date? = nil,
            endDate: Date? = nil,
            tagId: String? = nil,
            type: TransactionType? = nil,
            userId: String? = nil,
            sortedOrder: APIManager.SortedOrderType? = nil
        ) {
            self.ledgerId = ledgerId
            self.page = page
            self.limit = limit
            self.search = search
            self.startDate = startDate
            self.endDate = endDate
            self.tagId = tagId
            self.type = type
            self.userId = userId
            self.sortedOrder = sortedOrder
        }

        func getUrl(path: String) throws -> URL {
            guard var components = URLComponents(string: path) else { throw APIManagerError.badUrl }
            components.queryItems = [
                .init(name: "ledgerId", value: ledgerId),
                .init(name: "page", value: page.toString()),
                .init(name: "limit", value: limit.toString()),
                .init(name: "search", value: search),
                .init(name: "startDate", value: startDate?.formatted(.iso8601)),
                .init(name: "endDate", value: endDate?.formatted(.iso8601)),
                .init(name: "tagId", value: tagId),
                .init(name: "type", value: type?.rawValue),
                .init(name: "userId", value: userId),
                .init(name: "sortedOrder", value: sortedOrder?.rawValue)
            ]
            guard let url = components.url else { throw APIManagerError.badUrl }
            return url
        }
    }

    func getTransactionByLedger(config: TransactionGetByLedgerQuery) async throws -> [TransactionData] {
        let url = try config.getUrl(path: APIPath.Transaction.getByLedger.getPath())
        let request = genRequest(url: url, method: .GET)
        do {
            let (data, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw TransactionError.failedGetTransaction }
            let result = try APIManager.decoder.decode(TransactionsResponse.self, from: data)
            return result.data.transactions
        } catch {
            throw TransactionError.failedGetTransaction
        }
    }
}
