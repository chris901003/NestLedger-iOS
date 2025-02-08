// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct UserInfoData {
    var userName: String
    var emailAddress: String?
    var avatar: UIImage?
    var timeZone: Int
    var version: Int

    init(
        userName: String,
        emailAddress: String? = nil,
        avatar: UIImage? = nil,
        timeZone: Int = 8,
        version: Int = USER_INFO_DATA_VERSION
    ) {
        self.userName = userName
        self.emailAddress = emailAddress
        self.avatar = avatar
        self.timeZone = timeZone
        self.version = version
    }

    static func initMock() -> UserInfoData {
        .init(
            userName: "Mock user",
            emailAddress: "mock@xxooooxx.org",
            avatar: nil,
            timeZone: 8,
            version: USER_INFO_DATA_VERSION
        )
    }
}
