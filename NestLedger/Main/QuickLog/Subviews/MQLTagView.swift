// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MQLTagView: UIView {
    let colorView = UIView()
    let tagLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        colorView.layer.cornerRadius = 15 / 2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.secondaryLabel.cgColor

        tagLabel.text = "點擊選擇類別"
        tagLabel.textColor = .secondaryLabel
        tagLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tagLabel.numberOfLines = 1
        tagLabel.textAlignment = .center
    }

    private func layout() {
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            colorView.heightAnchor.constraint(equalToConstant: 15),
            colorView.widthAnchor.constraint(equalToConstant: 15)
        ])

        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
