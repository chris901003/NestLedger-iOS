// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

// MARK: - Send Email Verification
extension NewAPIManager {
    func sendEmailVerification(emailAddress: String) async throws {
        let responseData = await session.request(
            NewAPIPath.EmailVerification.send.getPath(),
            method: .get,
            parameters: ["emailAddress": emailAddress])
            .serializingData()
            .response
        try checkResponse(responseData: responseData)
    }
}
