// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MCDateCell: UICollectionViewCell {
    static let cellId = "MCDateCellId"

    var date: Date? = nil
    var amount: Int = 0

    let dateLabel = UILabel()
    let amountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        dateLabel.text = ""
    }

    func config(date: String, amount: Int) {
        self.amount = amount
        dateLabel.text = date
        amountLabel.text = date.isEmpty ? "" : "\(amount)"
        amountLabel.textColor = amount >= 0 ? .systemGreen : .systemRed
    }

    func isSelected(_ isSelected: Bool) {
        if isSelected {
            backgroundColor = amount >= 0 ? .systemGreen.withAlphaComponent(0.3) : .systemRed.withAlphaComponent(0.3)
        } else {
            backgroundColor = .clear
        }
    }

    private func setup() {
        layer.cornerRadius = 10.0

        dateLabel.text = "1"
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center

        amountLabel.text = "0"
        amountLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        amountLabel.numberOfLines = 1
        amountLabel.textAlignment = .center
    }

    private func layout() {
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor, constant: -8)
        ])

        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
