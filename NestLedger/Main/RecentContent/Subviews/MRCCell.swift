// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class MRCCell: UITableViewCell {
    let typeLabel = XOUILabelPadding(padding: .init(top: 4, left: 6, bottom: 4, right: 6))
    let tagLabel = XOUILabelPadding(padding: .init(top: 4, left: 6, bottom: 4, right: 6))
    let titleLabel = UILabel()
    let amountLabel = UILabel()

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

    func config(data: TransactionData) {
        typeLabel.text = data.type.getLabel()
        typeLabel.backgroundColor = data.type.getBackgroundColor()

        titleLabel.text = data.title

        amountLabel.text = (data.type == .income ? "+" : "-") + "\(data.money)"
        amountLabel.textColor = data.type.getBackgroundColor()

        tagId = data.tagId

        if let tagData = CacheTagData.shared.getTagData(tagId: tagId) {
            configTagData(data: tagData)
        } else {
            Task {
                do {
                    let tag = try await getTagInformation(tagId: data.tagId)
                    await MainActor.run { configTagData(data: tag) }
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取標籤失敗")
                }
            }
        }
    }

    private func configTagData(data: TagData) {
        tagLabel.text = data.label
        tagLabel.textColor = data.getColor
        tagLabel.backgroundColor = data.getColor.withAlphaComponent(0.3)
    }

    private func setup() {
        selectionStyle = .none

        typeLabel.text = TransactionType.income.getLabel()
        typeLabel.numberOfLines = 1
        typeLabel.textColor = .white
        typeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        typeLabel.backgroundColor = TransactionType.income.getBackgroundColor()
        typeLabel.clipsToBounds = true
        typeLabel.layer.cornerRadius = 10.0

        tagLabel.text = "TAG"
        tagLabel.numberOfLines = 1
        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLabel.textColor = .systemOrange
        tagLabel.backgroundColor = .systemOrange.withAlphaComponent(0.3)
        tagLabel.clipsToBounds = true
        tagLabel.layer.cornerRadius = 10.0

        titleLabel.text = ""
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        amountLabel.text = "0"
        amountLabel.numberOfLines = 1
        amountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        amountLabel.textColor = TransactionType.income.getBackgroundColor()
    }

    private func layout() {
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 12),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])

        contentView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
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

// MARK: - Utility
extension MRCCell {
    private func getTagInformation(tagId: String) async throws -> TagData {
        let newApiManager = NewAPIManager()
        let tagData = try await newApiManager.getTag(tagId: tagId)
        CacheTagData.shared.updateTagData(tagData: tagData)
        return tagData
    }

    @objc private func receiveUpdateTagNotification(_ notification: Notification) {
        guard let updateTagData = NLNotification.decodeUpdateTag(notification),
              updateTagData._id == tagId else { return }
        tagLabel.text = updateTagData.label
        tagLabel.textColor = updateTagData.getColor
        tagLabel.backgroundColor = updateTagData.getColor.withAlphaComponent(0.3)
    }
}
