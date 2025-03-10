// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct TagData: Codable {
    var label: String
    var color: String
    var ledgerId: String
    var version: Int

    var getColor: UIColor { UIColor(hexCode: color) }
}

struct TagDataWrapper: Codable {
    let Tag: TagData
}

struct TagsDataWrapper: Codable {
    let tags: [TagData]
}

typealias TagDataResponse = APIResponseData<TagDataWrapper>
typealias TagsDataResponse = APIResponseData<TagsDataWrapper>
