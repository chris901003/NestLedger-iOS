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
    }

    enum Information: String, NewAPIPathProtocol {
        // [GET]
        case basic = "/v1/information/basic"
    }
}
