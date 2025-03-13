// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class APIManager {
    enum HttpMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }

    enum APIManagerError: LocalizedError {
        case badUrl

        var errorDescription: String? {
            switch self {
                case .badUrl:
                    return "Failed to get url"
            }
        }
    }

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: dateString)!
        })
        return decoder
    }()
    static private var _authToken = ""
    static var authToken: String {
        get { return "Bearer \(APIManager._authToken)" }
        set { APIManager._authToken = newValue }
    }

    func genRequest(url: URL, method: HttpMethod, body: [String: Any]? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(APIManager.authToken, forHTTPHeaderField: "Authorization")

        if let body, let jsonData = try? JSONSerialization.data(withJSONObject: body) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        }
        return request
    }
}

extension APIManager {
    enum APIManagerSendError: LocalizedError {
        case failedRefreshToken

        var errorDescription: String? {
            switch self {
                case .failedRefreshToken:
                    return "Failed refresh token"
            }
        }
    }

    /**
     對發送 API 進行包裝，當 refreshToken 為 true 時，如果 token 過期會有一次的刷新機會
     - Authors: HongYan
     */
    func send(request: URLRequest, refreshToken: Bool = true) async throws -> (Data, URLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        if refreshToken,
           let response = response as? HTTPURLResponse,
           response.statusCode == 403 {
            do {
                try await FirebaseAuthManager.shared.refreshTokenIfNeeded()
                var newRequest = request
                newRequest.setValue(APIManager.authToken, forHTTPHeaderField: "Authorization")
                return try await send(request: request, refreshToken: false)
            } catch {
                throw APIManagerSendError.failedRefreshToken
            }
        }
        return (data, response)
    }
}
