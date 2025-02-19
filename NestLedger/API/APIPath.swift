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

        // [PATCH]
        case update = "/user/update"
    }

    enum Information: String, APIPathProtocol {
        // [GET]
        case basic = "/information/basic"
    }
}
