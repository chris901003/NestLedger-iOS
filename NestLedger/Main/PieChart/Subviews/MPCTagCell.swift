// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MPCTagCell: UITableViewCell {
    static let cellId = "MPCTagCellId"

    let tagColor = UIView()
    let tagLabel = UILabel()
    let percentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(label: String, color: UIColor, percent: Int) {
        tagColor.backgroundColor = color
        tagLabel.text = label
        percentLabel.text = "\(percent)%"
    }

    private func setup() {
        selectionStyle = .none

        tagColor.layer.cornerRadius = 10.0
        tagColor.clipsToBounds = true

        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLabel.numberOfLines = 1
        tagLabel.textColor = .black
        tagLabel.textAlignment = .left

        percentLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        percentLabel.numberOfLines = 1
        percentLabel.textAlignment = .right
        percentLabel.textColor = .black
    }

    private func layout() {
        contentView.addSubview(tagColor)
        tagColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagColor.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            tagColor.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagColor.heightAnchor.constraint(equalToConstant: 20),
            tagColor.widthAnchor.constraint(equalTo: tagColor.heightAnchor)
        ])

        contentView.addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            percentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: tagColor.trailingAnchor, constant: 8),
            tagLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8)
        ])
    }
}
