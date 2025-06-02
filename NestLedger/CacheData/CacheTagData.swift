// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Collections

class CacheTagData {
    static let shared = CacheTagData()

    private let maxLength: Int = 100
    private var data: [String: TagData] = [:]
    private var deque: Deque<String> = []

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeCacheTagData), name: .refreshLedgerDetailView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeCacheTagData), name: .refreshMainView, object: nil)
    }

    func getTagData(tagId: String) -> TagData? {
        guard let index = deque.firstIndex(of: tagId) else { return nil }
        deque.remove(at: index)
        deque.append(tagId)
        return data[tagId]
    }

    func updateTagData(tagData: TagData) {
        if let index = deque.firstIndex(of: tagData._id) {
            deque.remove(at: index)
        }
        data[tagData._id] = tagData
        deque.append(tagData._id)
        if deque.count > maxLength {
            let firstId = deque.removeFirst()
            data[firstId] = nil
        }
    }

    @objc private func removeCacheTagData(_ notification: Notification) {
        guard let ledgerId = NLNotification.decodeRefreshLedgerDetail(notification) else { return }
        let tagIds = data.values.compactMap { $0.ledgerId == ledgerId ? $0._id : nil }
        for tagId in tagIds {
            if let index = deque.firstIndex(of: tagId) {
                deque.remove(at: index)
            }
            data[tagId] = nil
        }
    }
}
