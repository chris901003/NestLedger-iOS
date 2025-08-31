// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class FeedbackManager {
    var allowDismiss = false
    let newAPIManager = NewAPIManager()

    func sendFeedback(feedbackData: UserFeedbackRequestData) async throws {
        try await newAPIManager.createUserFeedback(data: feedbackData)
        allowDismiss = true
    }
}
