// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LSDInviteCellDelegate: AnyObject {
    func deleteInvite(_ cell: LSDInviteCell)
}

class LSDInviteCell: UITableViewCell {
    static let cellId = "LSDInviteCellID"

    let avatarView = UIImageView()
    let usernameLabel = UILabel()
    let countdownLabel = NLCountdownLabel()
    let deleteButton = UIImageView()

    let newAPIManager = NewAPIManager()
    var inviteData: LedgerSplitUserInviteData?
    weak var delegate: LSDInviteCellDelegate?

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

    func config(data: LedgerSplitUserInviteData) {
        self.inviteData = data
        Task {
            do {
                let userInfo = try await newAPIManager.getUserInfoByUid(uid: data.receiveUserId)
                let avatar = await CacheUserAvatarManager.shared.getUserAvatar(userId: data.receiveUserId)
                await MainActor.run {
                    if let avatar {
                        avatarView.image = avatar
                    }
                    usernameLabel.text = userInfo.userName
                    countdownLabel.startCountdown(to: data.expireAt)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "加載使用者失敗")
            }
        }
    }

    private func defaultConfig() {
        avatarView.image = UIImage(named: "avatar")
        usernameLabel.text = "Unknown"
        countdownLabel.startCountdown(to: .now)
    }

    private func setup() {
        defaultConfig()

        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 25.0

        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .black

        countdownLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        countdownLabel.textColor = .secondaryLabel

        deleteButton.image = UIImage(systemName: "xmark.app")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.isUserInteractionEnabled = true
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteAction)))
    }

    private func layout() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            avatarView.widthAnchor.constraint(equalToConstant: 50)
        ])

        contentView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16)
        ])

        contentView.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            countdownLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2)
        ])

        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

// MARK: - Utility
extension LSDInviteCell {
    @objc private func tapDeleteAction() {
        guard let inviteData else { return }
        Task {
            do {
                try await newAPIManager.ledgerSplitDeleteUserInvite(inviteId: inviteData.id, accept: false)
                await MainActor.run {
                    delegate?.deleteInvite(self)
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "刪除失敗，請稍後嘗試")
            }
        }
    }
}
