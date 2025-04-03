// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/3.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class TTagSelectionButtonView: UIView {
    let contentView = UIView()
    let tagColorView = UIView()
    let tagTitleLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(tag: TagData?) {
        if let tag {
            tagColorView.backgroundColor = tag.getColor
            tagTitleLabel.text = tag.label
        } else {
            tagColorView.backgroundColor = .clear
            tagTitleLabel.text = "點擊選擇標籤"
        }
    }

    private func setup() {
        layer.cornerRadius = 20.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.systemGray4.cgColor

        tagColorView.backgroundColor = .clear
        tagColorView.clipsToBounds = true
        tagColorView.layer.borderWidth = 1.5
        tagColorView.layer.borderColor = UIColor.systemGray.cgColor
        tagColorView.layer.cornerRadius = 25.0 / 2

        tagTitleLabel.text = "點擊選擇標籤"
        tagTitleLabel.textColor = .systemGray
        tagTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tagTitleLabel.numberOfLines = 1
    }

    private func layout() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        contentView.addSubview(tagColorView)
        tagColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tagColorView.heightAnchor.constraint(equalToConstant: 25),
            tagColorView.widthAnchor.constraint(equalTo: tagColorView.heightAnchor)
        ])

        contentView.addSubview(tagTitleLabel)
        tagTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagTitleLabel.leadingAnchor.constraint(equalTo: tagColorView.trailingAnchor, constant: 8),
            tagTitleLabel.centerYAnchor.constraint(equalTo: tagColorView.centerYAnchor),
            tagTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
