// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol TIncomeExpenseSelectorViewDelegate: AnyObject {
    func changeType(type: TransactionType)
}

fileprivate extension TransactionType {
    var backgroundColor: UIColor {
        switch self {
            case .income:
                return UIColor(hexCode: "C8E6C9")
            case .expenditure:
                return UIColor(hexCode: "FFCDD2")
        }
    }
}

class TIncomeExpenseSelectorView: UIView {
    let incomeLabel = XOUILabelPadding(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    let expenseLabel = XOUILabelPadding(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    let selectedView = UIView()

    var selectedViewLeadingConstraint: NSLayoutConstraint?
    weak var delegate: TIncomeExpenseSelectorViewDelegate?

    var type: TransactionType = .income {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let self else { return }
                    selectedView.backgroundColor = type.backgroundColor
                    selectedViewLeadingConstraint?.constant = type == .income ? 0 : selectedView.bounds.width
                    layoutIfNeeded()
                }
            }
            delegate?.changeType(type: type)
        }
    }

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(type: TransactionType) {
        self.type = type
    }

    private func setup() {
        backgroundColor = .systemGray4
        layer.cornerRadius = 15.0
        clipsToBounds = true

        incomeLabel.text = "收入"
        incomeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        incomeLabel.textColor = UIColor(hexCode: "1B5E20")
        incomeLabel.numberOfLines = 1
        incomeLabel.textAlignment = .center
        incomeLabel.isUserInteractionEnabled = true
        incomeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(incomeAction)))

        expenseLabel.text = "支出"
        expenseLabel.font = .systemFont(ofSize: 16, weight: .bold)
        expenseLabel.textColor = UIColor(hexCode: "B71C1C")
        expenseLabel.numberOfLines = 1
        expenseLabel.textAlignment = .center
        expenseLabel.isUserInteractionEnabled = true
        expenseLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expenseAction)))

        selectedView.backgroundColor = type.backgroundColor
    }

    private func layout() {
        addSubview(selectedView)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        selectedViewLeadingConstraint = selectedView.leadingAnchor.constraint(equalTo: leadingAnchor)
        selectedViewLeadingConstraint?.isActive = true

        addSubview(incomeLabel)
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeLabel.topAnchor.constraint(equalTo: topAnchor),
            incomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            incomeLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            incomeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(expenseLabel)
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseLabel.topAnchor.constraint(equalTo: topAnchor),
            expenseLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            expenseLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            expenseLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        selectedView.widthAnchor.constraint(equalTo: incomeLabel.widthAnchor).isActive = true
    }
}

extension TIncomeExpenseSelectorView {
    @objc private func incomeAction() {
        type = .income
    }

    @objc private func expenseAction() {
        type = .expenditure
    }
}
