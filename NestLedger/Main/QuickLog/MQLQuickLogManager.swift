// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/6.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

class MQLQuickLogManager { }

extension MQLQuickLogManager: MQLSendViewDelegate {
    func sendAction(completion: @escaping () -> Void) {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            completion()
        }
    }
}
