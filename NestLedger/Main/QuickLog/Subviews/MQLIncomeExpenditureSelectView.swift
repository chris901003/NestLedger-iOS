// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol MQLIncomeExpenditureSelectViewDelegate: AnyObject {
    func changeValueType(type: MQLIncomeExpenditureSelectView.SelectedType)
}

extension MQLIncomeExpenditureSelectView {
    enum SelectedType {
        case income, expenditure

        var backgroundColor: UIColor {
            switch self {
                case .income:
                    return UIColor(hexCode: "C8E6C9")
                case .expenditure:
                    return UIColor(hexCode: "FFCDD2")
            }
        }
    }
}

class MQLIncomeExpenditureSelectView: UIView {
    let incomeLabel = UILabel()
    let expenditureLabel = UILabel()
    let selectedView = UIView()

    var selectedViewLeadingConstraint: NSLayoutConstraint?
    var selectedViewWidthConstraint: NSLayoutConstraint?

    var delegate: MQLIncomeExpenditureSelectViewDelegate?

    var selectedType = SelectedType.income {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let self else { return }
                    selectedView.backgroundColor = selectedType.backgroundColor
                    selectedViewLeadingConstraint?.constant = selectedType == .income ? 0 : selectedView.bounds.width
                    layoutIfNeeded()
                }
            }
            delegate?.changeValueType(type: selectedType)
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

    private func setup() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 15.0
        clipsToBounds = true

        selectedView.backgroundColor = selectedType.backgroundColor

        incomeLabel.text = "收入"
        incomeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        incomeLabel.textColor = UIColor(hexCode: "1B5E20")
        incomeLabel.numberOfLines = 1
        incomeLabel.textAlignment = .center
        incomeLabel.isUserInteractionEnabled = true
        incomeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapIncomeAction)))

        expenditureLabel.text = "支出"
        expenditureLabel.font = .systemFont(ofSize: 16, weight: .bold)
        expenditureLabel.textColor = UIColor(hexCode: "B71C1C")
        expenditureLabel.numberOfLines = 1
        expenditureLabel.textAlignment = .center
        expenditureLabel.isUserInteractionEnabled = true
        expenditureLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapExpenditureAction)))
    }

    private func layout() {
        addSubview(selectedView)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        selectedViewLeadingConstraint = selectedView.leadingAnchor.constraint(equalTo: leadingAnchor)
        selectedViewLeadingConstraint?.isActive = true

        addSubview(incomeLabel)
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            incomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            incomeLabel.trailingAnchor.constraint(equalTo: centerXAnchor)
        ])

        addSubview(expenditureLabel)
        expenditureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenditureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            expenditureLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            expenditureLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        selectedViewWidthConstraint = selectedView.widthAnchor.constraint(equalTo: incomeLabel.widthAnchor)
        selectedViewWidthConstraint?.isActive = true
    }

    @objc private func tapIncomeAction() {
        selectedType = .income
    }

    @objc private func tapExpenditureAction() {
        selectedType = .expenditure
    }
}
