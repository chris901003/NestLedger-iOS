// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSCreateManager {
    var ledgerSplitData = LedgerSplitData.initMock()
    var ledgerAvatar: UIImage?

    func createLedgerSplit() async -> String? {
        if ledgerSplitData.title.isEmpty {
            return "請輸入分帳本名稱"
        }
        return nil
    }
}
