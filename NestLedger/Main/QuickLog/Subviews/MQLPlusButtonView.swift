// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MQLPlusButtonView: UIView {
    let value: Int
    let label = UILabel()

    init(title: String, value: Int) {
        self.value = value
        super.init(frame: .zero)
        setup(title)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(_ title: String) {
        label.text = title
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
    }

    private func layout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
