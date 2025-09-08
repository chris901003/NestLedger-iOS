// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class NLCTitleCell: UICollectionViewCell {
    static let cellId = "NLCTitleCellId"

    let date = ["日", "一", "二", "三", "四", "五", "六"]
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(_ date: Int) {
        titleLabel.text = self.date[date]
    }

    private func setup() {
        titleLabel.text = "日"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
    }

    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
