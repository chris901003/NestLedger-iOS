// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSDetailErrorView: UIView {
    let iconImageView = UIImageView()
    let label = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        iconImageView.image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit

        label.text = "統計發生錯誤，請稍後再嘗試..."
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGray
    }

    private func layout() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25)
        ])

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
