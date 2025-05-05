// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

var sharedUserInfo = UserInfoData.initMock() {
    didSet {
        if let oldFirstLedgerId = oldValue.ledgerIds.first,
           let newFirstLedgerId = sharedUserInfo.ledgerIds.first,
           oldFirstLedgerId != newFirstLedgerId {
            DispatchQueue.main.async { NLNotification.sendSetMainLedger(ledgerId: newFirstLedgerId) }
        }
    }
}
