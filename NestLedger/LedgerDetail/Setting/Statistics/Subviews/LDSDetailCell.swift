// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSDetailCell: UITableViewCell {
    static let cellId = "LDSDetailCellId"

    let tagCircleView = UIView()
    let tagPercentage = UILabel()
    let tagLabel = UILabel()
    let tagPercentageView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        defaultConfig()
    }

    private func defaultConfig() {
        tagCircleView.backgroundColor = .black
        tagPercentage.text = "0 %"
        tagLabel.text = "未知標籤"
    }

    private func setup() {
        defaultConfig()

        selectionStyle = .none

        tagCircleView.layer.cornerRadius = 10

        tagPercentage.font = .systemFont(ofSize: 20, weight: .semibold)
        tagPercentage.textAlignment = .right

        tagLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tagLabel.textAlignment = .left

        tagPercentageView.layer.cornerRadius = 6.0
        tagPercentageView.backgroundColor = .systemGray6
    }

    private func layout() {
        contentView.addSubview(tagCircleView)
        tagCircleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagCircleView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            tagCircleView.widthAnchor.constraint(equalToConstant: 20),
            tagCircleView.heightAnchor.constraint(equalToConstant: 20)
        ])

        contentView.addSubview(tagPercentage)
        tagPercentage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagPercentage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagPercentage.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
        tagPercentage.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: tagLabel.topAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: tagCircleView.trailingAnchor, constant: 12),
            tagLabel.trailingAnchor.constraint(equalTo: tagPercentage.leadingAnchor, constant: -12)
        ])
        tagLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        contentView.addSubview(tagPercentageView)
        tagPercentageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagPercentageView.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 4),
            tagPercentageView.leadingAnchor.constraint(equalTo: tagCircleView.trailingAnchor, constant: 12),
            tagPercentageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            tagPercentageView.trailingAnchor.constraint(equalTo: tagPercentage.leadingAnchor, constant: -12),
            tagPercentageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        tagPercentageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
