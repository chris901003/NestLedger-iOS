// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import Combine

extension LSTAmountView {
    class AmountView: UIView {
        let titleLabel = UILabel()
        let amountLabel = UILabel()

        let transactionStore: LSTransactionStore
        var cancellables = Set<AnyCancellable>()

        init(transactionStore: LSTransactionStore) {
            self.transactionStore = transactionStore
            super.init(frame: .zero)
            setup()
            layout()
            subscribeAmount()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            layer.cornerRadius = 10.0
            layer.borderColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1).cgColor
            layer.borderWidth = 1.5

            titleLabel.text = "總金額:"
            titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

            amountLabel.text = "$ \(transactionStore.amount)"
            amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        }

        private func layout() {
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

            addSubview(amountLabel)
            amountLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
                amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }

        private func subscribeAmount() {
            transactionStore.amountPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.amountLabel.text = "$ \(value)"
                }
                .store(in: &cancellables)
        }
    }
}
