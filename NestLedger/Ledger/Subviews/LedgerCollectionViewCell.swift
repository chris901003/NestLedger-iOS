// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension LedgerCollectionViewCell {
    static let backgroundColors = [
        UIColor(hexCode: "F6BEAD"), UIColor(hexCode: "CAB4D7"), UIColor(hexCode: "B4B9D7"), UIColor(hexCode: "B7D1CB"),
        UIColor(hexCode: "AFD0E4"), UIColor(hexCode: "F6E0AD"), UIColor(hexCode: "B8D5BC")
    ]
}

class LedgerCollectionViewCell: UICollectionViewCell {
    static let cellId = "LedgerCollectionViewCellId"

    let userIconsView = (first: UIImageView(), second: UIImageView(), third: UIImageView())
    let ledgerView = UIView()
    let ledgerLabel = UILabel()

    let newApiManager = NewAPIManager()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }

    func config(ledgerData: LedgerData) {
        if ledgerData.title == "[Main]:" + newSharedUserInfo.id {
            ledgerLabel.text = "我的帳本"
        } else {
            ledgerLabel.text = ledgerData.title
        }
        Task { await loadUserAvatar(data: ledgerData) }
    }

    private func setupIcon(view: UIImageView) {
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.layer.cornerRadius = 35 / 2
        view.clipsToBounds = true
        view.image = nil
    }

    private func setup() {
        contentView.backgroundColor = LedgerCollectionViewCell.backgroundColors.randomElement()
        contentView.layer.cornerRadius = 15.0

        setupIcon(view: userIconsView.first)
        setupIcon(view: userIconsView.second)
        setupIcon(view: userIconsView.third)

        ledgerView.backgroundColor = .white
        ledgerView.layer.cornerRadius = 10.0
        ledgerView.clipsToBounds = true

        ledgerLabel.text = "帳本名稱"
        ledgerLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        ledgerLabel.textColor = .black
        ledgerLabel.numberOfLines = 1
        ledgerLabel.textAlignment = .center
    }

    private func layout() {
        contentView.addSubview(userIconsView.second)
        userIconsView.second.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIconsView.second.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userIconsView.second.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userIconsView.second.widthAnchor.constraint(equalToConstant: 35),
            userIconsView.second.heightAnchor.constraint(equalTo: userIconsView.second.widthAnchor)
        ])

        contentView.addSubview(userIconsView.first)
        userIconsView.first.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIconsView.first.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userIconsView.first.trailingAnchor.constraint(equalTo: userIconsView.second.leadingAnchor, constant: -18),
            userIconsView.first.heightAnchor.constraint(equalToConstant: 35),
            userIconsView.first.widthAnchor.constraint(equalToConstant: 35)
        ])

        contentView.addSubview(userIconsView.third)
        userIconsView.third.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIconsView.third.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userIconsView.third.leadingAnchor.constraint(equalTo: userIconsView.second.trailingAnchor, constant: 18),
            userIconsView.third.heightAnchor.constraint(equalToConstant: 35),
            userIconsView.third.widthAnchor.constraint(equalToConstant: 35)
        ])

        contentView.addSubview(ledgerView)
        ledgerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerView.topAnchor.constraint(equalTo: userIconsView.second.bottomAnchor, constant: 24),
            ledgerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ledgerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ledgerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        ledgerView.addSubview(ledgerLabel)
        ledgerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerLabel.centerXAnchor.constraint(equalTo: ledgerView.centerXAnchor),
            ledgerLabel.centerYAnchor.constraint(equalTo: ledgerView.centerYAnchor)
        ])
    }
}

extension LedgerCollectionViewCell {
    private func loadUserAvatar(data: LedgerData) async {
        let userIds = data.userIds.prefix(3)
        let userAvatars = try? await withThrowingTaskGroup(of: (UIImage?, Int).self, returning: [UIImage].self) { group in
            for idx in 0..<userIds.count {
                group.addTask { [weak self] in
                    if let avatar = CacheUserAvatar.shared.getTagData(userId: userIds[idx]) {
                        return (avatar, idx)
                    } else {
                        return (try? await self?.newApiManager.getUserAvatar(uid: userIds[idx]), idx)
                    }
                }
            }
            var results = Array(repeating: UIImage(), count: userIds.count)
            for try await result in group {
                if let image = result.0 {
                    results[result.1] = image
                    CacheUserAvatar.shared.updateTagData(userId: userIds[result.1], avatar: image)
                } else {
                    results[result.1] = generateBlackImage(size: .init(width: 100, height: 100))
                }
            }
            return results
        }
        guard let userAvatars else { return }
        await MainActor.run {
            userIconsView.first.image = userAvatars[0]
            if userAvatars.count >= 2 {
                userIconsView.second.image = userAvatars[1]
            }
            if userAvatars.count >= 3 {
                userIconsView.third.image = userAvatars[2]
            }
        }
    }

    func generateBlackImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
