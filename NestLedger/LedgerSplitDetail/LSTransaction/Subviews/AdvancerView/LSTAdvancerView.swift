// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LSTAdvancerView: UIView {
    let titleLabel = UILabel()
    let avatarView = UIImageView()
    let usernameLabel = UILabel()

    let menuButton = UIButton()

    let ledgerSplitData: LedgerSplitData
    let transactionStore: LSTransactionStore
    let newAPIManager = NewAPIManager()

    init(ledgerSplitData: LedgerSplitData, transactionStore: LSTransactionStore) {
        self.ledgerSplitData = ledgerSplitData
        self.transactionStore = transactionStore
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1).cgColor
        layer.borderWidth = 1.5

        titleLabel.text = "墊付人:"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        avatarView.contentMode = .scaleAspectFill
        avatarView.image = UIImage(named: "avatar")
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 35.0 / 2

        usernameLabel.text = "請選擇墊付人"
        usernameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .secondaryLabel

        menuButton.setTitle("請選擇墊付人", for: .normal)
        menuButton.alpha = 0.02
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = createMenu()
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.trailingAnchor.constraint(equalTo: usernameLabel.leadingAnchor, constant: -8),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 35),
            avatarView.widthAnchor.constraint(equalToConstant: 35)
        ])

        addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: avatarView.topAnchor),
            menuButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
            menuButton.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            menuButton.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
    }
}

// MARK: - Menu
extension LSTAdvancerView {
    private func createMenu() -> UIMenu {
        let deferred = UIDeferredMenuElement { completion in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let userInfos = try await newAPIManager.getMultipleUserInfo(uids: ledgerSplitData.userIds)
                    let actions = userInfos.map { userInfo in
                        UIAction(title: userInfo.userName) { [weak self] _ in
                            self?.selectUserInfo(userInfo: userInfo)
                        }
                    }
                    completion(actions)
                } catch {
                    completion([])
                }
            }
        }
        return UIMenu(title: "選擇墊付人", children: [deferred])
    }

    private func selectUserInfo(userInfo: UserInfoData) {
        usernameLabel.text = userInfo.userName
        usernameLabel.textColor = .black

        Task {
            let avatar = await CacheUserAvatarManager.shared.getUserAvatar(userId: userInfo.id)
            await MainActor.run {
                avatarView.image = avatar
                transactionStore.advancer = userInfo
            }
        }
    }
}
