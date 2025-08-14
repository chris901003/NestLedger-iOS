// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

actor CacheLedgerSplitAvatarManager {
    static let shared = CacheLedgerSplitAvatarManager()
    private init() { }

    private let newApiManager = NewAPIManager()
    private var cache = NSCache<NSString, UIImage>()
    private var inflight: [String: Task<UIImage?, Never>] = [:]

    func getLedgerSplitAvatar(ledgerSplitId: String) async -> UIImage? {
        if let image = cache.object(forKey: ledgerSplitId as NSString) { return image }

        // Fetching
        if let task = inflight[ledgerSplitId] { return await task.value }

        // Fetch
        let task = Task<UIImage?, Never> {
            do {
                let image = try await newApiManager.getLedgerSplitAvatar(ledgerSplitId: ledgerSplitId)
                cache.setObject(image, forKey: ledgerSplitId as NSString)
                return image
            } catch {
                return nil
            }
        }
        inflight[ledgerSplitId] = task
        let result = await task.value
        inflight.removeValue(forKey: ledgerSplitId)
        return result
    }
}
