// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/3.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import Collections

class CacheUserAvatar {
    static let shared = CacheUserAvatar()

    private let maxLength: Int = 50
    private var data: [String: UIImage] = [:]
    private var deque: Deque<String> = []

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeAllCacheUserAvatars), name: .refreshLedgerListView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeCacheUserAvatars), name: .refreshUserAvatarCache, object: nil)
    }

    func getTagData(userId: String) -> UIImage? {
        guard let index = deque.firstIndex(of: userId) else { return nil }
        deque.remove(at: index)
        deque.append(userId)
        return data[userId]
    }

    func updateTagData(userId: String, avatar: UIImage) {
        if let index = deque.firstIndex(of: userId) {
            deque.remove(at: index)
        }
        data[userId] = avatar
        deque.append(userId)
        if deque.count > maxLength {
            let firstId = deque.removeFirst()
            data[firstId] = nil
        }
    }

    @objc private func removeAllCacheUserAvatars() {
        data.removeAll()
        deque.removeAll()
    }

    @objc private func removeCacheUserAvatars(_ notification: Notification) {
        guard let uids = NLNotification.decodeRefreshUserAvatarCache(notification) else { return }
        for uid in uids {
            if let index = deque.firstIndex(of: uid) {
                deque.remove(at: index)
            }
            data[uid] = nil
        }
    }
}
