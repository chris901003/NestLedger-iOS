// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

actor CacheUserAvatarManager {
    static let shared = CacheUserAvatarManager()
    private init() { }

    private let newApiManager = NewAPIManager()
    private var cache = NSCache<NSString, UIImage>()
    private var inflight: [String: Task<UIImage?, Never>] = [:]

    func getUserAvatar(userId: String) async -> UIImage? {
        if let image = cache.object(forKey: userId as NSString) { return image }

        // Fetching
        if let task = inflight[userId] { return await task.value }

        // Fetch
        let task = Task<UIImage?, Never> {
            do {
                let image = try await newApiManager.getUserAvatar(uid: userId)
                cache.setObject(image, forKey: userId as NSString)
                return image
            } catch {
                return nil
            }
        }
        inflight[userId] = task
        let result = await task.value
        inflight.removeValue(forKey: userId)
        return result
    }
}
