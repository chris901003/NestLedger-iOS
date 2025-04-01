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

    var income: Int = 0
    var expense: Int = 0

    init() {
        super.init(frame: .zero)
        setup()
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNewTransaction), name: .newRecentTransaction, object: nil)
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

        incomeLabel.text = "收入\n$\(income)"
        expenseLabel.text = "支出\n$\(expense)"

        self.income = income
        self.expense = expense
    }

    private func setup() {
        lineView.layer.cornerRadius = 10.0
        lineView.clipsToBounds = true
        lineView.backgroundColor = .blue

        incomeLine.backgroundColor = UIColor(hexCode: "#B1DD8B")
        expenseLine.backgroundColor = UIColor(hexCode: "#FF8484")

        incomeLabel.text = "收入\n$0"
        incomeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        incomeLabel.numberOfLines = 0
        incomeLabel.textColor = UIColor(hexCode: "#B1DD8B")
        incomeLabel.textAlignment = .left

        expenseLabel.text = "支出\n$0"
        expenseLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        expenseLabel.numberOfLines = 0
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
            incomeLine.heightAnchor.constraint(equalToConstant: 25),
            incomeLine.bottomAnchor.constraint(equalTo: lineView.bottomAnchor)
        ])
        incomeLineWidthConstraint = incomeLine.widthAnchor.constraint(equalToConstant: 200)
        incomeLineWidthConstraint?.isActive = true

        lineView.addSubview(expenseLine)
        expenseLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseLine.topAnchor.constraint(equalTo: lineView.topAnchor),
            expenseLine.leadingAnchor.constraint(equalTo: incomeLine.trailingAnchor),
            expenseLine.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            expenseLine.heightAnchor.constraint(equalToConstant: 25),
            expenseLine.bottomAnchor.constraint(equalTo: lineView.bottomAnchor)
        ])

        addSubview(incomeLabel)
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            incomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            incomeLabel.heightAnchor.constraint(equalToConstant: 60),
            bottomAnchor.constraint(greaterThanOrEqualTo: incomeLabel.bottomAnchor),
        ])

        addSubview(expenseLabel)
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            expenseLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            expenseLabel.heightAnchor.constraint(equalToConstant: 60),
            bottomAnchor.constraint(equalTo: expenseLabel.bottomAnchor)
        ])
    }
}

extension LDIncomeExpenseView {
    @objc private func receiveNewTransaction(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let transaction = userInfo["transaction"] as? TransactionData else { return }
        if transaction.type == .income {
            income += transaction.money
        } else if transaction.type == .expenditure {
            expense += transaction.money
        }
        config(income: income, expense: expense)
    }
}
