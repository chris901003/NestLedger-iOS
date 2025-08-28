// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

// MARK: - Update App Version
extension SceneDelegate {
    func updateAppVersionAnalysis() {
        let newAPIManager = NewAPIManager()
        Task { await newAPIManager.updateAppVersion() }
    }
}
