// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/20.
// Copyright © 2025 HongYan. All rights reserved.

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var adaptedRequest = urlRequest
        adaptedRequest.setValue(NewAPIManager.authToken, forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let httpResponse = request.task?.response as? HTTPURLResponse,
           httpResponse.statusCode == 403 else {
            return completion(.doNotRetry)
        }

        Task {
            do {
                try await FirebaseAuthManager.shared.refreshTokenIfNeeded()
                completion(.retry)
            } catch {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

extension NewAPIManager {
    enum NewAPIManagerError: LocalizedError {
        case badRequest
        case badResponse
        case authFailed
        case othersStatusCodeFailed
        case responseDataNotFound

        var errorDescription: String? {
            switch self {
                case .badRequest:
                    return "Response Data Error"
                case .badResponse:
                    return "Response status code not found"
                case .authFailed:
                    return "Authentication failed"
                case .othersStatusCodeFailed:
                    return "Invalid status code (Server Error)"
                case .responseDataNotFound:
                    return "Response data not found"
            }
        }
    }
}

class NewAPIManager {
    static private var _authToken = ""
    static var authToken: String {
        get { return "Bearer \(NewAPIManager._authToken)" }
        set { NewAPIManager._authToken = newValue }
    }
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
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

    let session = Session(interceptor: AuthInterceptor())

    func checkResponse(responseData: DataResponse<Data, AFError>) throws {
        if let error = responseData.error { throw NewAPIManagerError.badRequest }
        guard let response = responseData.response else { throw NewAPIManagerError.badResponse }
        if response.statusCode == 403 { throw NewAPIManagerError.authFailed }
        guard response.statusCode == 200 else { throw NewAPIManagerError.othersStatusCodeFailed }
    }
}
