// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LDSLMInviteCellDelegate: NLNeedPresent {
    func deleteInviteUser(ledgerInviteId: String)
}

class LDSLMInviteCell: UITableViewCell {
    static let cellId = "LDSLMInviteCellId"

    let mainContentView = UIView()
    let senderAvatarView = UIImageView()
    let iconView = UIImageView()
    let receiveAvatarView = UIImageView()
    let nameLabel = UILabel()
    let deleteIcon = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "delete.backward")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    )

    var ledgerInviteId: String = "Mock Ledger Invite Id"
    weak var delegate: LDSLMInviteCellDelegate?

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
        nameLabel.text = "Unknown User"
        senderAvatarView.image = nil
        receiveAvatarView.image = nil
    }

    func config(senderAvatar: UIImage?, receiveAvatar: UIImage?, receiveName: String, ledgerInviteId: String) {
        senderAvatarView.image = senderAvatar
        receiveAvatarView.image = receiveAvatar
        nameLabel.text = receiveName
        self.ledgerInviteId = ledgerInviteId
    }

    private func setup() {
        selectionStyle = .none
        defaultConfig()

        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderWidth = 1.5
        mainContentView.layer.borderColor = UIColor.black.cgColor

        senderAvatarView.backgroundColor = .black
        senderAvatarView.layer.cornerRadius = 20.0
        senderAvatarView.clipsToBounds = true

        iconView.image = UIImage(systemName: "arrow.forward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit

        receiveAvatarView.backgroundColor = .black
        receiveAvatarView.layer.cornerRadius = 20.0
        receiveAvatarView.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.numberOfLines = 1

        deleteIcon.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        deleteIcon.layer.cornerRadius = 10.0
        deleteIcon.clipsToBounds = true
        deleteIcon.isUserInteractionEnabled = true
        deleteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteAction)))
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

        mainContentView.addSubview(senderAvatarView)
        senderAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            senderAvatarView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8),
            senderAvatarView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            senderAvatarView.widthAnchor.constraint(equalToConstant: 40),
            senderAvatarView.heightAnchor.constraint(equalToConstant: 40),
            senderAvatarView.bottomAnchor.constraint(lessThanOrEqualTo: mainContentView.bottomAnchor, constant: -8)
        ])

        mainContentView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: senderAvatarView.trailingAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 25),
            iconView.widthAnchor.constraint(equalToConstant: 25)
        ])

        mainContentView.addSubview(receiveAvatarView)
        receiveAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            receiveAvatarView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            receiveAvatarView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            receiveAvatarView.heightAnchor.constraint(equalToConstant: 40),
            receiveAvatarView.widthAnchor.constraint(equalToConstant: 40)
        ])

        mainContentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: receiveAvatarView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor)
        ])

        mainContentView.addSubview(deleteIcon)
        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteIcon.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            deleteIcon.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            deleteIcon.widthAnchor.constraint(equalToConstant: 30),
            deleteIcon.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func tapDeleteAction() {
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { [weak self] _ in
            guard let self else { return }
            delegate?.deleteInviteUser(ledgerInviteId: ledgerInviteId)
        }
        let alertController = UIAlertController(title: "刪除邀請", message: "確定要取消此邀請嗎?", preferredStyle: .alert)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        delegate?.presentVC(alertController)
    }
}
