// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LPlusButtonView: UIButton {
    let iconView = UIImageView()
    let countLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(infoCount: Int) {
        countLabel.alpha = infoCount > 0 ? 1 : 0
        countLabel.text = infoCount <= 9 ? "\(infoCount)" : "9+"
    }

    private func setup() {
        iconView.image = UIImage(systemName: "plus")
        iconView.contentMode = .scaleAspectFit

        countLabel.alpha = 0
        countLabel.text = "0"
        countLabel.numberOfLines = 1
        countLabel.textAlignment = .center
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 8, weight: .semibold)
        countLabel.layer.cornerRadius = 7
        countLabel.clipsToBounds = true
        countLabel.backgroundColor = .systemRed
    }

    private func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])

        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: iconView.centerXAnchor, constant: 4),
            countLabel.bottomAnchor.constraint(equalTo: iconView.centerYAnchor, constant: -4),
            countLabel.widthAnchor.constraint(equalToConstant: 14),
            countLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
