// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

protocol NewAPIPathProtocol: RawRepresentable where RawValue == String {
    func getPath() -> String
    func getUrl() -> URL?
}

extension NewAPIPathProtocol {
    func getPath() -> String {
        "\(NewAPIPath.base)\(self.rawValue)"
    }

    func getUrl() -> URL? {
        URL(string: self.getPath())
    }
}

class NewAPIPath {
    static let base = "https://nlbackendmain-nlk.xxooooxx.org:1172"

    enum UserInfo: String, NewAPIPathProtocol {
        // [GET]
        case login = "/v1/user/login"
        case get = "/v1/user/get"
        case avatar = "/v1/user/avatar"
        case getUserById = "/v1/user/get-user-by-uid"
        case getMultipleUserInfo = "/v1/user/get-multiple-user-info"
        case getUserByEmail = "/v1/user/get-user-by-email"

        // [POST]
        case uploadAvatar = "/v1/user/upload-avatar"

        // [PATCH]
        case update = "/v1/user/update"
        case changeQuickLogLedger = "/v1/user/change-quick-log-ledger"

        // [DELETE]
        case delete = "/v1/user/delete"
    }

    enum Information: String, NewAPIPathProtocol {
        // [GET]
        case basic = "/v1/information/basic"
    }

    enum Tag: String, NewAPIPathProtocol {
        // [POST]
        case create = "/v1/tag/create"
        case get = "/v1/tag/get"
        case query = "/v1/tag/query"
        case copy = "/v1/tag/copy"

        // [PATCH]
        case update = "/v1/tag/update"

        // [DELETE]
        case delete = "/v1/tag/delete"
    }

    enum Transaction: String, NewAPIPathProtocol {
        // [POST]
        case create = "/v1/transaction/create"
        case query = "/v1/transaction/query"

        // [PATCH]
        case update = "/v1/transaction/update"

        // [DELETE]
        case delete = "/v1/transaction/delete"
    }

    enum Ledger: String, NewAPIPathProtocol {
        // [GET]
        case get = "/v1/ledger/get"
        case leave = "/v1/ledger/leave"
        case setUserNickName = "/v1/ledger/setUserName"

        // [POST]
        case create = "/v1/ledger/create"

        // [PATCH]
        case update = "/v1/ledger/update"
    }

    enum LedgerInvite: String, NewAPIPathProtocol {
        // [GET]
        case get = "/v1/ledger-invite/get"
        case createLink = "/v1/ledger-invite/create-link"

        // [POST]
        case create = "/v1/ledger-invite/create"

        // [DELETE]
        case delete = "/v1/ledger-invite/delete"
    }

    enum EmailVerification: String, NewAPIPathProtocol {
        // [GET]
        case get = "/v1/email-verification/get"
        case send = "/v1/email-verification/send"
    }

    enum LedgerSplit: String, NewAPIPathProtocol {
        // [GET]
        case get = "/v1/ledger-split/get"
        case avatar = "/v1/ledger-split/avatar"

        // [POST]
        case create = "/v1/ledger-split/create"
        case uploadAvatar = "/v1/ledger-split/upload-avatar"

        // [PATCH]
        case update = "/v1/ledger-split/update"
    }
}
