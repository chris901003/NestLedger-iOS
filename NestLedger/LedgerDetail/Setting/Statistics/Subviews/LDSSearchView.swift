// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSSearchView: UIView {
    let iconView = UIImageView()
    let labelView = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 15.0
        layer.borderWidth = 2.5
        layer.borderColor = UIColor(hexCode: "#C4E1E6").cgColor

        iconView.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.init(hexCode: "#A4CCD9"), renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit

        labelView.text = "搜尋"
        labelView.textColor = .init(hexCode: "#A4CCD9")
        labelView.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    private func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            iconView.widthAnchor.constraint(equalToConstant: 30)
        ])

        addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 36),
            labelView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36)
        ])
    }
}
