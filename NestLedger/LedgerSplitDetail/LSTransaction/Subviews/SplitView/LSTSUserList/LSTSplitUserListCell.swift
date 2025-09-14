// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LSTSplitUserListCellDelegate: AnyObject {
    func userJoin(_ cell: LSTSplitUserListCell)
}

class LSTSplitUserListCell: UITableViewCell {
    static let cellId = "LSTSplitUserListCellId"
    let newAPIManager = NewAPIManager()

    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let joinButton = XOBorderLabel("加入", color: .systemBlue, padding: .init(top: 6, left: 8, bottom: 6, right: 8))

    weak var delegate: LSTSplitUserListCellDelegate?

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
        avatarView.image = UIImage(named: "avatar")
        nameLabel.text = "未知"
    }

    func config(userId: String) {
        Task {
            let userInfo = try? await newAPIManager.getUserInfoByUid(uid: userId)
            let avatar = await CacheUserAvatarManager.shared.getUserAvatar(userId: userId)
            await MainActor.run {
                avatarView.image = avatar
                nameLabel.text = userInfo?.userName
            }
        }
    }

    private func setup() {
        selectionStyle = .none

        defaultConfig()

        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 20
        avatarView.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        joinButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapJoinAction)))
        joinButton.isUserInteractionEnabled = true
    }

    private func layout() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 40),
            avatarView.widthAnchor.constraint(equalToConstant: 40)
        ])

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12)
        ])

        contentView.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            joinButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func tapJoinAction() {
        delegate?.userJoin(self)
    }
}
