// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/5/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class RLICell: UITableViewCell {
    static let cellId = "RLICellId"

    let mainContentView = UIView()
    let ledgerTitleLabel = UILabel()
    let inviteUserAvatar = UIImageView()
    let inviteUserNameLabel = UILabel()
    let acceptView = XOBorderLabel("同意", color: .systemBlue, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    let rejectView = XOBorderLabel("拒絕", color: .systemRed, padding: .init(top: 8, left: 8, bottom: 8, right: 8))

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
        ledgerTitleLabel.text = "默認帳本名稱"
        inviteUserAvatar.image = nil
        inviteUserNameLabel.text = "未知使用者"
    }

    private func setup() {
        selectionStyle = .none
        defaultConfig()

        mainContentView.layer.cornerRadius = 10.0
        mainContentView.layer.borderWidth = 1.5
        mainContentView.layer.borderColor = UIColor.black.cgColor

        ledgerTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        ledgerTitleLabel.textAlignment = .left
        ledgerTitleLabel.numberOfLines = 1

        inviteUserAvatar.backgroundColor = .black
        inviteUserAvatar.clipsToBounds = true
        inviteUserAvatar.layer.cornerRadius = 20.0

        inviteUserNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        inviteUserNameLabel.textAlignment = .left
        inviteUserNameLabel.numberOfLines = 1
    }

    private func layout() {
        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        mainContentView.addSubview(ledgerTitleLabel)
        ledgerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerTitleLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            ledgerTitleLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8)
        ])

        mainContentView.addSubview(inviteUserAvatar)
        inviteUserAvatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteUserAvatar.topAnchor.constraint(equalTo: ledgerTitleLabel.bottomAnchor, constant: 12),
            inviteUserAvatar.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8),
            inviteUserAvatar.widthAnchor.constraint(equalToConstant: 40),
            inviteUserAvatar.heightAnchor.constraint(equalToConstant: 40),
            inviteUserAvatar.bottomAnchor.constraint(lessThanOrEqualTo: mainContentView.bottomAnchor, constant: -12)
        ])

        mainContentView.addSubview(inviteUserNameLabel)
        inviteUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteUserNameLabel.centerYAnchor.constraint(equalTo: inviteUserAvatar.centerYAnchor),
            inviteUserNameLabel.leadingAnchor.constraint(equalTo: inviteUserAvatar.trailingAnchor, constant: 8)
        ])

        mainContentView.addSubview(acceptView)
        acceptView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -8),
            acceptView.bottomAnchor.constraint(equalTo: mainContentView.centerYAnchor, constant: -4)
        ])

        mainContentView.addSubview(rejectView)
        rejectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rejectView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -8),
            rejectView.topAnchor.constraint(equalTo: mainContentView.centerYAnchor, constant: 4)
        ])
    }
}
