// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSCTTagCell: UITableViewCell {
    static let cellId = "LDSCTTagCellId"

    let circleView = UIView()
    let tagLabel = UILabel()
    let deleteButton = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defaultConfig() {
        circleView.backgroundColor = .systemGray5
        tagLabel.text = "標籤名稱"
    }

    private func setup() {
        selectionStyle = .none
        defaultConfig()

        circleView.layer.cornerRadius = 10

        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLabel.textAlignment = .left

        deleteButton.image = UIImage(systemName: "xmark.app")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        deleteButton.contentMode = .scaleAspectFit
    }

    private func layout() {
        contentView.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 20),
            circleView.widthAnchor.constraint(equalToConstant: 20)
        ])

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
