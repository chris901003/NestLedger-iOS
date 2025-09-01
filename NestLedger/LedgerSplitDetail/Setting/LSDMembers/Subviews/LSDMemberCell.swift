// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSDMemberCell: UITableViewCell {
    static let cellId = "LSDMemberCellId"

    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let deleteButton = UIImageView()

    let newAPIManager = NewAPIManager()
    var userId: String?
    var userType: LSDMemberViewController.Sections?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(userId: String, type: LSDMemberViewController.Sections) {
        self.userId = userId
        self.userType = type
        fetchUserInfo()
    }

    private func setup() {
        selectionStyle = .none

        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.image = UIImage(named: "avatar")
        avatarView.layer.cornerRadius = 25.0

        nameLabel.text = "未知使用者"
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        deleteButton.image = UIImage(systemName: "xmark.app")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.isUserInteractionEnabled = true
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteAction)))
    }

    private func layout() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            avatarView.widthAnchor.constraint(equalToConstant: 50)
        ])

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12)
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
extension LSDMemberCell {
    func fetchUserInfo() {
        guard let userId else { return }
        Task {
            do {
                let userData = try await newAPIManager.getUserInfoByUid(uid: userId)
                let userAvatar = await CacheUserAvatarManager.shared.getUserAvatar(userId: userId)
                await MainActor.run {
                    nameLabel.text = userData.userName
                    avatarView.image = userAvatar ?? UIImage(named: "avatar")
                }
            } catch {
                await MainActor.run {
                    nameLabel.text = "獲取使用者資料失敗"
                }
            }
        }
    }

    @objc private func tapDeleteAction() {
        print("✅ Tap Delete Action")
    }
}
