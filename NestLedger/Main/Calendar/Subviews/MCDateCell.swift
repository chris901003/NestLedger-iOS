// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MCDateCell: UICollectionViewCell {
    static let cellId = "MCDateCellId"

    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(date: String) {
        dateLabel.text = date
    }

    private func setup() {
        backgroundColor = .systemGray
        dateLabel.text = "1"
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center
    }

    private func layout() {
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
