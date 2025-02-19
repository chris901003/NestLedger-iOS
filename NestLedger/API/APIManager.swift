// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class APIManager {
    static private var _authToken = ""
    static var authToken: String {
        get { return "Bearer \(APIManager._authToken)" }
        set { APIManager._authToken = newValue }
    }

    func genGetRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIManager.authToken, forHTTPHeaderField: "Authorization")
        return request
    }
}
