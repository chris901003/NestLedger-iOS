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
    static let base = "https://nlbackendmain.xxooooxx.org:1172"

    enum UserInfo: String, NewAPIPathProtocol {
        // [GET]
        case login = "/v1/user/login"
        case get = "/v1/user/get"
        case avatar = "/v1/user/avatar"

        // [POST]
        case uploadAvatar = "/v1/user/upload-avatar"

        // [PATCH]
        case update = "/v1/user/update"

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
        case query = "/v1/tag/query"

        // [PATCH]
        case update = "/v1/tag/update"

        // [DELETE]
        case delete = "/v1/tag/delete"
    }

    enum Transaction: String, NewAPIPathProtocol {
        // [POST]
        case create = "/v1/transaction/create"
        case query = "/v1/transaction/query"
    }
}
