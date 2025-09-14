// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LSTSplitCellDelegate: AnyObject {
    func updateSplitAmount(_ cell: LSTSplitCell, amount: Int)
}

class LSTSplitCell: UITableViewCell {
    static let cellId = "LSTSplitCellId"

    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let amountLabel = UITextField()

    let newAPIManager = NewAPIManager()
    weak var delegate: LSTSplitCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(userId: String, amount: Int) {
        Task {
            let userInfo = try? await newAPIManager.getUserInfoByUid(uid: userId)
            let avatar = await CacheUserAvatarManager.shared.getUserAvatar(userId: userId)
            await MainActor.run {
                avatarView.image = avatar
                nameLabel.text = userInfo?.userName
                amountLabel.text = "\(amount)"
            }
        }
    }

    private func defaultConfig() {
        avatarView.image = UIImage(named: "avatar")
        nameLabel.text = "未知"
    }

    private func setup() {
        defaultConfig()
        selectionStyle = .none

        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 25

        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)

        amountLabel.placeholder = "輸入金額"
        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.keyboardType = .numberPad
        amountLabel.delegate = self
    }

    private func layout() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            avatarView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            avatarView.widthAnchor.constraint(equalToConstant: 50)
        ])

        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LSTSplitCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateSplitAmount(self, amount: Int(textField.text ?? "0") ?? 0)
    }
}
