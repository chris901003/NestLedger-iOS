// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension CacheTagManager {
    final class TagDataWrapper {
        let value: TagData

        init(value: TagData) { self.value = value }
    }
}

actor CacheTagManager {
    static let shared = CacheTagManager()
    private init() { }

    private let newApiManager = NewAPIManager()
    private var cache = NSCache<NSString, TagDataWrapper>()
    private var inflight: [String: Task<TagData?, Never>] = [:]

    func getTag(tagId: String) async -> TagData? {
        if let tagData = cache.object(forKey: tagId as NSString) { return tagData.value }

        // Fetching
        if let task = inflight[tagId] { return await task.value }

        // Fetch
        let task = Task<TagData?, Never> {
            do {
                let tagData = try await newApiManager.getTag(tagId: tagId)
                cache.setObject(.init(value: tagData), forKey: tagId as NSString)
                return tagData
            } catch {
                return nil
            }
        }
        inflight[tagId] = task
        let result = await task.value
        inflight.removeValue(forKey: tagId)
        return result
    }
}
