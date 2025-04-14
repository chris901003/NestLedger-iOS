// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDAddTransactionView: UIView {
    let iconView = UIImageView()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 60 / 2
        clipsToBounds = true
        backgroundColor = .systemBlue

        iconView.image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
    }

    private func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 25),
            iconView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
