// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

enum BasicError: LocalizedError {
    case common(msg: String)

    var errorDescription: String? {
        switch self {
            case .common(let msg):
                return msg
        }
    }
}
