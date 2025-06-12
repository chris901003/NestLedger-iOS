// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSCTTargetLedgerSelectView: UIView {
    let titleLabel = UILabel()
    let titleBackgroundView = UIView()
    let targetLedgerLabel = UITextField()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.borderColor = UIColor(hexCode: "#56DFCF").cgColor
        layer.borderWidth = 2.5
        layer.cornerRadius = 20.0
        clipsToBounds = true

        titleLabel.text = "目標帳本"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        titleBackgroundView.backgroundColor = UIColor(hexCode: "#ADEED9")

        targetLedgerLabel.placeholder = "點擊選擇目標帳本"
        targetLedgerLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        targetLedgerLabel.isUserInteractionEnabled = false
        targetLedgerLabel.textAlignment = .right
    }

    private func layout() {
        addSubview(titleBackgroundView)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleBackgroundView.widthAnchor.constraint(equalToConstant: 90)
        ])

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])

        addSubview(targetLedgerLabel)
        targetLedgerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetLedgerLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: 8),
            targetLedgerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            targetLedgerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
