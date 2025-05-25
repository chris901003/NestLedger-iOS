// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class BasicUserInfoViewController: UIViewController {
    let contentView = UIView()
    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let emailAddressLabel = UILabel()

    var userInfoData: UserInfoData

    init(userInfoData: UserInfoData) {
        self.userInfoData = userInfoData
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
        getAvatar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        view.backgroundColor = .white

        avatarView.backgroundColor = .black
        avatarView.layer.cornerRadius = 50
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill

        nameLabel.text = userInfoData.userName
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1

        emailAddressLabel.text = userInfoData.emailAddress
        emailAddressLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        emailAddressLabel.textAlignment = .left
        emailAddressLabel.numberOfLines = 1
        emailAddressLabel.textColor = .systemGray2
    }

    private func layout() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])

        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100)
        ])

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 24),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -6),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        contentView.addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 24),
            emailAddressLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 6),
            emailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension BasicUserInfoViewController {
    private func getAvatar() {
        Task {
            let newApiManager = NewAPIManager()
            let image = try? await newApiManager.getUserAvatar(uid: userInfoData.id)
            await MainActor.run { avatarView.image = image }
        }
    }
}
