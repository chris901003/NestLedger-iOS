// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSCButtonView: UIView {
    let label = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(title: String, color: UIColor) {
        layer.borderColor = color.cgColor
        label.text = title
        label.textColor = color
    }

    private func setup() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5

        label.text = "按鈕"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
    }

    private func layout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
