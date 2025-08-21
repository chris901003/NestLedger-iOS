// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import Combine

@MainActor
final class LedgerSplitDetailStore {
    @Published private(set) var data: LedgerSplitData
    @Published private(set) var avatar: UIImage

    var dataPublisher: AnyPublisher<LedgerSplitData, Never> {
        $data
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    var avatarPublisher: AnyPublisher<UIImage, Never> {
        $avatar
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    init(data: LedgerSplitData, avatar: UIImage) {
        self.data = data
        self.avatar = avatar
    }

    func update(ledgerSplitData: LedgerSplitData? = nil, avatar: UIImage? = nil) {
        if let ledgerSplitData {
            self.data = ledgerSplitData
        }
        if let avatar {
            self.avatar = avatar
        }
    }
}
