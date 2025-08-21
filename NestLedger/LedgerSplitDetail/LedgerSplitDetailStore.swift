// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import Combine

@MainActor
final class LedgerSplitDetailStore {
    @Published private(set) var data: LedgerSplitData

    var dataPublisher: AnyPublisher<LedgerSplitData, Never> {
        $data
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    init(data: LedgerSplitData) { self.data = data }

    func update(_ data: LedgerSplitData) {
        self.data = data
    }
}
