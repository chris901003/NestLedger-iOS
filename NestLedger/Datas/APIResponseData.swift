// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct APIBaseResponseData: Decodable {
    let code: Int
    let success: Bool
    let message: String
}

struct APIResponseData<T: Codable>: Codable {
    let success: Bool
    let message: String
    let data: T
}

struct APIFailedResponseData: Codable {
    let success: Bool
    let message: String
}
