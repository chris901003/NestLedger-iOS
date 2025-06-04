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
    let copyIconView = UIImageView()

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

        copyIconView.image = UIImage(systemName: "doc.on.doc")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        copyIconView.contentMode = .scaleAspectFit
        copyIconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyEmailAddress)))
        copyIconView.isUserInteractionEnabled = true
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

        contentView.addSubview(copyIconView)
        copyIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyIconView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 24),
            copyIconView.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 6),
            copyIconView.widthAnchor.constraint(equalToConstant: 16),
            copyIconView.heightAnchor.constraint(equalToConstant: 16)
        ])

        contentView.addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressLabel.leadingAnchor.constraint(equalTo: copyIconView.trailingAnchor, constant: 8),
            emailAddressLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 6),
            emailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    @objc private func copyEmailAddress() {
        UIPasteboard.general.string = emailAddressLabel.text
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.copyIconView.image = UIImage(systemName: "checkmark")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        }
    }
}

extension BasicUserInfoViewController {
    private func getAvatar() {
        if let avatar = CacheUserAvatar.shared.getTagData(userId: userInfoData.id) {
            avatarView.image = avatar
        } else {
            Task {
                let newApiManager = NewAPIManager()
                guard let image = try? await newApiManager.getUserAvatar(uid: userInfoData.id) else { return }
                CacheUserAvatar.shared.updateTagData(userId: userInfoData.id, avatar: image)
                await MainActor.run { avatarView.image = image }
            }
        }
    }
}
