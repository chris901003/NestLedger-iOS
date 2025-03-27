// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDIncomeExpenseView: UIView {
    let lineView = UIView()
    let incomeLine = UIView()
    let expenseLine = UIView()
    let incomeLabel = UILabel()
    let expenseLabel = UILabel()

    var incomePercentage: CGFloat = 0.5
    var incomeLineWidthConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        incomeLineWidthConstraint?.constant = bounds.width * incomePercentage
    }

    func config(income: Int, expense: Int) {
        if income + expense == 0 {
            incomePercentage = 0.5
        } else {
            incomePercentage = CGFloat(income) / CGFloat(income + expense)
        }
        incomeLineWidthConstraint?.constant = bounds.width * incomePercentage
        layoutIfNeeded()

        incomeLabel.text = "收入\n$\(income)"
        expenseLabel.text = "支出\n$\(expense)"
    }

    private func setup() {
        lineView.layer.cornerRadius = 5.0
        lineView.clipsToBounds = true

        incomeLine.backgroundColor = UIColor(hexCode: "#B1DD8B")
        expenseLine.backgroundColor = UIColor(hexCode: "#FF8484")

        incomeLabel.text = "收入\n$0"
        incomeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        incomeLabel.numberOfLines = 2
        incomeLabel.textColor = UIColor(hexCode: "#B1DD8B")
        incomeLabel.textAlignment = .left

        expenseLabel.text = "支出\n$0"
        expenseLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        expenseLabel.numberOfLines = 2
        expenseLabel.textColor = UIColor(hexCode: "#FF8484")
        expenseLabel.textAlignment = .right
    }

    private func layout() {
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        lineView.addSubview(incomeLine)
        incomeLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeLine.topAnchor.constraint(equalTo: lineView.topAnchor),
            incomeLine.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
            incomeLine.heightAnchor.constraint(equalToConstant: 10),
            incomeLine.bottomAnchor.constraint(equalTo: lineView.bottomAnchor)
        ])
        incomeLineWidthConstraint = incomeLine.widthAnchor.constraint(equalToConstant: 200)
        incomeLineWidthConstraint?.isActive = true

        lineView.addSubview(expenseLine)
        expenseLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseLine.topAnchor.constraint(equalTo: incomeLine.topAnchor),
            expenseLine.leadingAnchor.constraint(equalTo: incomeLine.trailingAnchor),
            expenseLine.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            expenseLine.bottomAnchor.constraint(equalTo: incomeLine.bottomAnchor)
        ])

        addSubview(incomeLabel)
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            incomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(expenseLabel)
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            expenseLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
