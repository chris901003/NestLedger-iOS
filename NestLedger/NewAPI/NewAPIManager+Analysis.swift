// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Alamofire

// MARK: - Update App Version Analysis
extension NewAPIManager {
    func updateAppVersion() async {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
        let _ = await session.request(
            NewAPIPath.Analysis.appVersion.getPath(),
            method: .get,
            parameters: ["appVersion": appVersion])
            .validate()
            .serializingData()
            .response
    }
}
