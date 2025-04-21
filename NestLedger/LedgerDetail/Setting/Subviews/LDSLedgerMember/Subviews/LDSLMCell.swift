// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LDSLMCellDelegate: NLNeedPresent {
    func tapDeleteAction(userId: String)
}

class LDSLMCell: UITableViewCell {
    static let cellId = "LDSLMCellId"

    let mainContentView = UIView()
    let avatarView = UIImageView()
    let userNameLabel = UILabel()
    let deleteIcon = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    )

    var userId: String = ""
    weak var delegate: LDSLMCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(avatar: UIImage?, userName: String, userId: String) {
        avatarView.image = avatar
        userNameLabel.text = userName
        self.userId = userId
    }

    private func setDefault() {
        avatarView.image = nil
        userNameLabel.text = "Unkonwn User"
    }

    private func setup() {
        setDefault()
        selectionStyle = .none

        mainContentView.layer.cornerRadius = 15.0
        mainContentView.layer.borderWidth = 1.5
        mainContentView.layer.borderColor = UIColor.black.cgColor

        avatarView.backgroundColor = .black
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 20.0
        avatarView.clipsToBounds = true

        userNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        userNameLabel.textColor = .black
        userNameLabel.textAlignment = .left
        userNameLabel.numberOfLines = 1

        deleteIcon.backgroundColor = .red.withAlphaComponent(0.2)
        deleteIcon.layer.cornerRadius = 10.0
        deleteIcon.clipsToBounds = true
        deleteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteAction)))
        deleteIcon.isUserInteractionEnabled = true
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

        mainContentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8),
            avatarView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: mainContentView.bottomAnchor, constant: -8),
        ])

        mainContentView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12)
        ])

        mainContentView.addSubview(deleteIcon)
        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteIcon.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            deleteIcon.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            deleteIcon.widthAnchor.constraint(equalToConstant: 30),
            deleteIcon.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension LDSLMCell {
    @objc private func tapDeleteAction() {
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let deleteAction = UIAlertAction(title: "確定", style: .destructive) { [weak self] _ in
            guard let self else { return }
            delegate?.tapDeleteAction(userId: userId)
        }
        let controller = UIAlertController(title: "刪除使用者", message: "確定要刪除該使用者嗎?", preferredStyle: .alert)
        controller.addAction(cancelAction)
        controller.addAction(deleteAction)
        delegate?.presentVC(controller)
    }
}
