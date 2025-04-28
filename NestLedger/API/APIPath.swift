// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

protocol APIPathProtocol: RawRepresentable where RawValue == String {
    func getPath() -> String
    func getUrl() -> URL?
}

extension APIPathProtocol {
    func getPath() -> String {
        "\(APIPath.base)\(self.rawValue)"
    }

    func getUrl() -> URL? {
        URL(string: self.getPath())
    }
}

class APIPath {
    static let base = "https://nestledgermain.xxooooxx.org:1172"

    enum UserInfo: String, APIPathProtocol {
        // [GET]
        case login = "/user/login"
        case userInfo = "/user/get"
        case getAvatar = "/user/get-avatar"
        case getByUid = "/user/get-user-by-uid"
        case getByEmailAddress = "/user/get-user-by-email"
        case getMultipleUserInfo = "/user/get-multiple-user-info"

        // [PATCH]
        case update = "/user/update"
    }

    enum Information: String, APIPathProtocol {
        // [GET]
        case basic = "/information/basic"
    }

    enum Photo: String, APIPathProtocol {
        // [POST]
        case single = "/photo/single"
    }

    enum Ledger: String, APIPathProtocol {
        // [GET]
        case get = "/ledger/get"

        // [POST]
        case create = "/ledger/create"
    }

    enum Tag: String, APIPathProtocol {
        // [GET]
        case get = "/tag/get"
        case getByLedger = "/tag/get-by-ledger"

        // [POST]
        case create = "/tag/create"

        // [DELETE]
        case delete = "/tag/delete"
    }

    enum Transaction: String, APIPathProtocol {
        // [GET]
        case getByLedger = "/transaction/get-by-ledger"

        // [POST]
        case create = "/transaction/create"

        // [PATCH]
        case update = "/transaction/update"

        // [DELETE]
        case delete = "/transaction/delete"
    }

    enum LedgerInvite: String, APIPathProtocol {
        // [GET]
        case get = "/ledger-invite/get"

        // [POST]
        case create = "/ledger-invite/create"

        // [DELETE]
        case delete = "/ledger-invite/delete"
    }
}
