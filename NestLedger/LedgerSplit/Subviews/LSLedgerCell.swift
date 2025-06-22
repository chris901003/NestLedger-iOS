// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension LSLedgerCell {
    static let borderColors = [
        UIColor(hexCode: "F6BEAD"), UIColor(hexCode: "CAB4D7"), UIColor(hexCode: "B4B9D7"), UIColor(hexCode: "B7D1CB"),
        UIColor(hexCode: "AFD0E4"), UIColor(hexCode: "F6E0AD"), UIColor(hexCode: "B8D5BC")
    ]
}

class LSLedgerCell: UITableViewCell {
    static let cellId = "LSLedgerCellId"

    let mainContentView = UIView()
    let ledgerAvatar = UIImageView()
    let ledgerLabel = UILabel()
    let totalLabel = UILabel()
    let userAvatars = [UIImageView](repeating: UIImageView(), count: 3)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        defaultConfig()
    }

    private func defaultConfig() {
        ledgerLabel.text = "分帳本名稱"
        ledgerAvatar.image = UIImage(named: "LedgerSplitIcon")
        totalLabel.text = "0"
    }

    private func setup() {
        defaultConfig()
        selectionStyle = .none

        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderWidth = 2.5
        mainContentView.layer.borderColor = LSLedgerCell.borderColors.randomElement()?.cgColor

        ledgerAvatar.contentMode = .scaleAspectFill
        ledgerAvatar.layer.cornerRadius = 25

        ledgerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        ledgerLabel.textAlignment = .left

        totalLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        totalLabel.textColor = .systemRed

        userAvatars[0].image = UIImage(named: "avatar")
        userAvatars[0].contentMode = .scaleAspectFill
        userAvatars[0].layer.cornerRadius = 15
    }

    private func layout() {
        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -12)
        ])

        mainContentView.addSubview(ledgerAvatar)
        ledgerAvatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerAvatar.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 12),
            ledgerAvatar.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 12),
            ledgerAvatar.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -12),
            ledgerAvatar.heightAnchor.constraint(equalToConstant: 50),
            ledgerAvatar.widthAnchor.constraint(equalToConstant: 50)
        ])

        mainContentView.addSubview(ledgerLabel)
        ledgerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 12),
            ledgerLabel.leadingAnchor.constraint(equalTo: ledgerAvatar.trailingAnchor, constant: 8),
            ledgerLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -8)
        ])

        mainContentView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalLabel.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16)
        ])

        mainContentView.addSubview(userAvatars[0])
        userAvatars[0].translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userAvatars[0].topAnchor.constraint(equalTo: mainContentView.centerYAnchor, constant: 2),
            userAvatars[0].leadingAnchor.constraint(equalTo: ledgerAvatar.trailingAnchor, constant: 8),
            userAvatars[0].heightAnchor.constraint(equalToConstant: 30),
            userAvatars[0].widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
