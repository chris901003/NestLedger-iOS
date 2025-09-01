// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LedgerSplitJoinViewController: UIViewController {
    let ledgerSplitId: String
    let token: String
    let manager = LedgerSplitJoinManager()

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let titleLabel = UILabel()
    let ledgerSplitAvatar = UIImageView()
    let ledgerSplitLabel = UILabel()
    let cancelButton = XOBorderLabel("取消", color: .systemRed, padding: .init(top: 6, left: 12, bottom: 6, right: 12))
    let joinButton = XOBorderLabel("加入", color: .systemBlue, padding: .init(top: 6, left: 12, bottom: 6, right: 12))

    init(ledgerSplitId: String, token: String) {
        self.ledgerSplitId = ledgerSplitId
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        getLedgerSplitData()
    }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0

        titleLabel.text = "加入分帳本"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center

        ledgerSplitAvatar.contentMode = .scaleAspectFill
        ledgerSplitAvatar.clipsToBounds = true
        ledgerSplitAvatar.layer.cornerRadius = 25.0
        ledgerSplitAvatar.image = UIImage(named: "LedgerSplitIcon")

        ledgerSplitLabel.text = "分帳本名稱"
        ledgerSplitLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        ledgerSplitLabel.textAlignment = .center

        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelAction)))
        cancelButton.isUserInteractionEnabled = true

        joinButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapJoinAction)))
        joinButton.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 3 / 4)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        view.addSubview(ledgerSplitAvatar)
        ledgerSplitAvatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerSplitAvatar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            ledgerSplitAvatar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ledgerSplitAvatar.heightAnchor.constraint(equalToConstant: 50),
            ledgerSplitAvatar.widthAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(ledgerSplitLabel)
        ledgerSplitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerSplitLabel.topAnchor.constraint(equalTo: ledgerSplitAvatar.bottomAnchor, constant: 12),
            ledgerSplitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            ledgerSplitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: ledgerSplitLabel.bottomAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -6),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        view.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinButton.topAnchor.constraint(equalTo: ledgerSplitLabel.bottomAnchor, constant: 24),
            joinButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 6),
            joinButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - Utility
extension LedgerSplitJoinViewController {
    private func getLedgerSplitData() {
        Task {
            do {
                let result = try await manager.getLedgerSplitData(ledgerSplitId: ledgerSplitId, token: token)
                await MainActor.run {
                    ledgerSplitLabel.text = result.ledgerSplitData.title
                    ledgerSplitAvatar.image = result.avatar ?? UIImage(named: "LedgerSplitIcon")
                }
            } catch {
                dismiss(animated: true) {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "該邀請連結已失效，請重新獲取邀請。")
                }
            }
        }
    }

    @objc private func tapCancelAction() {
        dismiss(animated: true)
    }

    @objc private func tapJoinAction() {
        Task {
            do {
                try await manager.joinLedgerSplit(token: token)
                dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "成功加入 \(ledgerSplitLabel.text ?? "")")
                }
            } catch {
                dismiss(animated: true) {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "加入失敗，請稍後再試。")
                }
            }
        }
    }
}
