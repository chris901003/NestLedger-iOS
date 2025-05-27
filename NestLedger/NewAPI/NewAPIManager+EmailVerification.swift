// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

extension NewAPIManager {
    enum EmailVerificationError: LocalizedError {
        case deocdeEmailVerificationFailed

        var errorDescription: String? {
            switch self {
                case .deocdeEmailVerificationFailed:
                    return "解析郵件認證失敗"
            }
        }
    }
}

// MARK: - Get Email Verification
extension NewAPIManager {
    func getEmailVerification() async throws -> EmailVerificationData? {
        let responseData = await session.request(NewAPIPath.EmailVerification.get.getPath())
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
        do {
            guard let data = responseData.data else { throw NewAPIManagerError.responseDataNotFound }
            return try NewAPIManager.decoder.decode(EmailVerificationResponse.self, from: data).data
        } catch {
            throw EmailVerificationError.deocdeEmailVerificationFailed
        }
    }
}

// MARK: - Send Email Verification
extension NewAPIManager {
    func sendEmailVerification(emailAddress: String) async throws {
        let responseData = await session.request(
            NewAPIPath.EmailVerification.send.getPath(),
            method: .get,
            parameters: ["emailAddress": emailAddress])
            .validate()
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
    }
}
