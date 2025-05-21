// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct UserInfoUpdateRequestData: Encodable {
    let id: String
    let userName: String?
    let emailAddress: String?
    let timeZone: Int?
    let imageQuality: Double?
    let version: Int?

    init(_ data: UserInfoData) {
        id = data.id
        userName = data.userName
        emailAddress = data.emailAddress
        timeZone = data.timeZone
        imageQuality = data.imageQuality
        version = data.version
    }
}
