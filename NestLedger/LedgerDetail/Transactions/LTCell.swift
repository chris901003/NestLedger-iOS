// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LTCell: UITableViewCell {
    static let cellId = "LTCellId"
    let avatarView = UIImageView()
    let typeLabel = XOUILabelPadding()
    let tagLabel = XOUILabelPadding()
    let amountLabel = UILabel()
    let titleLabel = UILabel()

    let newApiManager = NewAPIManager()
    var tagId = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()

        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateTagNotification), name: .updateTag, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        defaultSetup()
    }

    func config(transaction: TransactionData, avatar: UIImage?) {
        avatarView.image = avatar

        typeLabel.text = transaction.type.getLabel()
        typeLabel.backgroundColor = transaction.type.getBackgroundColor()

        amountLabel.text = "$\(transaction.money)"
        amountLabel.textColor = transaction.type.getBackgroundColor()

        titleLabel.text = transaction.title

        tagId = transaction.tagId
        Task { try? await fetchTagInfo(tagId: transaction.tagId) }
    }

    private func defaultSetup() {
        avatarView.image = nil

        typeLabel.text = "類別"
        typeLabel.backgroundColor = .black

        tagLabel.text = "標籤"
        tagLabel.backgroundColor = .black
        tagLabel.textColor = .white

        amountLabel.text = "$0"
        amountLabel.textColor = .black

        titleLabel.text = "內容"
    }

    private func setup() {
        selectionStyle = .none

        defaultSetup()

        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 40 / 2
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .systemGray5

        typeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        typeLabel.textColor = .white
        typeLabel.numberOfLines = 1
        typeLabel.layer.cornerRadius = 5.0
        typeLabel.clipsToBounds = true

        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLabel.numberOfLines = 1
        tagLabel.layer.cornerRadius = 5.0
        tagLabel.clipsToBounds = true

        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
    }

    private func layout() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40)
        ])

        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            typeLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        typeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 12),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
        tagLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
        amountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

extension LTCell {
    private func fetchTagInfo(tagId: String) async throws {
        let tagData = try await newApiManager.getTag(tagId: tagId)
        await MainActor.run {
            tagLabel.text = tagData.label
            tagLabel.textColor = tagData.getColor
            tagLabel.backgroundColor = tagData.getColor.withAlphaComponent(0.3)
        }
    }

    @objc private func receiveUpdateTagNotification(_ notification: Notification) {
        guard let newTagData = NLNotification.decodeUpdateTag(notification),
              newTagData._id == tagId else { return }

        tagLabel.text = newTagData.label
        tagLabel.textColor = newTagData.getColor
        tagLabel.backgroundColor = newTagData.getColor.withAlphaComponent(0.3)
    }
}

// MARK: - TransactionType Extension
fileprivate extension TransactionType {
    func getLabel() -> String {
        switch self {
            case .income:
                return "收入"
            case .expenditure:
                return "支出"
        }
    }

    func getBackgroundColor() -> UIColor {
        switch self {
            case .income:
                return UIColor(hexCode: "#B1DD8B")
            case .expenditure:
                return UIColor(hexCode: "#FF8484")
        }
    }
}
