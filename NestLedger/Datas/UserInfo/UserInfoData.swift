// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct UserInfoData: Codable {
    var id: String
    var userName: String
    var emailAddress: String
    var avatar: String
    var timeZone: Int
    var imageQuality: Double
    var ledgerIds: [String]
    var isDelete: Bool
    var version: Int

    init(
        id: String,
        userName: String,
        emailAddress: String = "",
        avatar: String = "",
        timeZone: Int = 8,
        imageQuality: Double = 0.5,
        ledgerIds: [String] = [],
        isDelete: Bool = false,
        version: Int = USER_INFO_DATA_VERSION
    ) {
        self.id = id
        self.userName = userName
        self.emailAddress = emailAddress
        self.avatar = avatar
        self.timeZone = timeZone
        self.imageQuality = imageQuality
        self.ledgerIds = ledgerIds
        self.isDelete = isDelete
        self.version = version
    }

    static func initMock() -> UserInfoData {
        .init(
            id: "Mock Id",
            userName: "Mock user",
            emailAddress: "mock@xxooooxx.org",
            avatar: "",
            timeZone: 8,
            imageQuality: 0.5,
            ledgerIds: [],
            isDelete: false,
            version: USER_INFO_DATA_VERSION
        )
    }
}

struct UserInfoDataWrapper: Codable {
    let UserInfo: UserInfoData
}

struct UserInfosDataWrapper: Codable {
    let userInfos: [UserInfoData]
}

typealias UserInfoResponse = APIResponseData<UserInfoDataWrapper>
typealias UserInfosResponse = APIResponseData<UserInfosDataWrapper>
typealias CleanUserInforesponse = APIResponseData<UserInfoData>
typealias CleanUserInfosResponse = APIResponseData<[UserInfoData]>
