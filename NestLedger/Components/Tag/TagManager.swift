// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

struct TagData {
    let label: String
    let color: String

    var getColor: UIColor { UIColor(hexCode: color) }
}

class TagManager {
    var showTags: [TagData] = [
        .init(label: "Test 1", color: "#eb4034"),
        .init(label: "Test 2", color: "#347deb")
    ]
}
