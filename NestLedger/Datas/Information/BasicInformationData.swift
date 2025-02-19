// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

struct BasicInformationData: Codable {
    var author: String = "Zephyr-Huang"
    var contactUs: String = "service@xxooooxx.org"
    var copyright: String = "Copyright © 2025 Zephyr-Huang"
}

typealias BasicInformationResponse = APIResponseData<BasicInformationData>
