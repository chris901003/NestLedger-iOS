// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation

extension TagViewController {
    enum SectionType: String, CaseIterable {
        case newTag = "添加新標籤"
        case existTag = "現有的標籤"

        var sectionHeaderHeight: CGFloat {
            switch self {
                case .newTag:
                    return 35
                case .existTag:
                    return 25
            }
        }
    }
}
