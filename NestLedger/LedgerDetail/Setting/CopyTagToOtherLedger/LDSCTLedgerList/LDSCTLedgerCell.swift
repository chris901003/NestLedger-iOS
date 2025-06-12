// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSCTLedgerCell: UITableViewCell {
    static let cellId = "LDSCTLedgerCellId"

    let mainContentView = UIView()
    let iconImageView = UIImageView()
    let labelView = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(ledgerTitle: String) {
        labelView.text = ledgerTitle
    }

    private func defaultConfig() {
        labelView.text = "帳目名稱"
    }

    private func setup() {
        defaultConfig()
        selectionStyle = .none

        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderColor = UIColor(hexCode: "#D1D8BE").cgColor
        mainContentView.layer.borderWidth = 1.5

        iconImageView.image = UIImage(systemName: "book.closed")?.withTintColor(UIColor(hexCode: "#D1D8BE"), renderingMode: .alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit

        labelView.font = .systemFont(ofSize: 16, weight: .semibold)
        labelView.textAlignment = .left
    }

    private func layout() {
        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        mainContentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30)
        ])

        mainContentView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            labelView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            labelView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor)
        ])
    }
}
