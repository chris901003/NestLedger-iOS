// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/11.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSTAmountView: UIView {
    let transactionStore: LSTransactionStore
    let amountSpace: CGFloat = 18

    let amountButton1: AmountButton
    let amountButton10: AmountButton
    let amountButton100: AmountButton
    let amountButton1000: AmountButton
    let amountView: AmountView

    let titleLabel = UILabel()

    init(transactionStore: LSTransactionStore) {
        self.transactionStore = transactionStore
        self.amountButton1 = AmountButton(value: 1, transactionStore: transactionStore)
        self.amountButton10 = AmountButton(value: 10, transactionStore: transactionStore)
        self.amountButton100 = AmountButton(value: 100, transactionStore: transactionStore)
        self.amountButton1000 = AmountButton(value: 1000, transactionStore: transactionStore)
        self.amountView = AmountView(transactionStore: transactionStore)
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = (bounds.width - amountSpace * 3) / 4
        let height: CGFloat = width / 1.5

        setupAmountSize(amountButton: amountButton1, width: width, height: height)
        setupAmountSize(amountButton: amountButton10, width: width, height: height)
        setupAmountSize(amountButton: amountButton100, width: width, height: height)
        setupAmountSize(amountButton: amountButton1000, width: width, height: height)
    }

    private func setup() {
        titleLabel.text = "總金額"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    private func layout() {
        layoutAmountButton(amountButton: amountButton1, leadingConstraint: leadingAnchor, constant: 0)
        layoutAmountButton(amountButton: amountButton10, leadingConstraint: amountButton1.trailingAnchor, constant: amountSpace)
        layoutAmountButton(amountButton: amountButton100, leadingConstraint: amountButton10.trailingAnchor, constant: amountSpace)
        layoutAmountButton(amountButton: amountButton1000, leadingConstraint: amountButton100.trailingAnchor, constant: amountSpace)

        addSubview(amountView)
        amountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountView.topAnchor.constraint(equalTo: amountButton1.bottomAnchor, constant: 12),
            amountView.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountView.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountView.bottomAnchor.constraint(equalTo: bottomAnchor),
            amountView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func layoutAmountButton(amountButton: UIView, leadingConstraint: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        addSubview(amountButton)
        amountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountButton.topAnchor.constraint(equalTo: topAnchor),
            amountButton.leadingAnchor.constraint(equalTo: leadingConstraint, constant: constant)
        ])
    }

    private func setupAmountSize(amountButton: UIView, width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            amountButton.heightAnchor.constraint(equalToConstant: height),
            amountButton.widthAnchor.constraint(equalToConstant: width)
        ])
    }
}
