// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension LSTAmountView {
    class AmountButton: UIView {
        let labelView = UILabel()
        let transactionStore: LSTransactionStore

        let value: Int

        init(value: Int, transactionStore: LSTransactionStore) {
            self.value = value
            self.transactionStore = transactionStore
            super.init(frame: .zero)
            setup()
            layout()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            backgroundColor = UIColor(red: 1, green: 245 / 255, blue: 222 / 255, alpha: 1)
            layer.cornerRadius = 10.0
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
            isUserInteractionEnabled = true

            labelView.text = "+\(value)"
            labelView.font = .systemFont(ofSize: 14, weight: .semibold)
            labelView.textColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1)
            labelView.textAlignment = .center
        }

        private func layout() {
            addSubview(labelView)
            labelView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelView.centerXAnchor.constraint(equalTo: centerXAnchor),
                labelView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }

        @objc private func tapAction() {
            transactionStore.addAmount(value)
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
        }
    }
}
