// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LedgerLinkJoinViewController: UIViewController {
    let token: String
    let ledgerId: String
    let manager = LedgerLinkJoinManager()

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let closeButton = UIImageView()
    let titleLabel = UILabel()
    let ledgerTitleLabel = UILabel()
    let cancelButton = XOBorderLabel("取消", color: .systemRed, padding: .init(top: 4, left: 6, bottom: 4, right: 6))
    let joinButton = XOBorderLabel("加入", color: .systemBlue, padding: .init(top: 4, left: 6, bottom: 4, right: 6))
    let loadingView = UIActivityIndicatorView(style: .medium)

    let errorLabel = UILabel()

    init(token: String, ledgerId: String) {
        self.token = token
        self.ledgerId = ledgerId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()

        Task {
            do {
                let ledgerData = try await manager.getLedgerData(ledgerId: ledgerId, token: token)
                await MainActor.run {
                    ledgerTitleLabel.text = ledgerData.title
                }
            } catch {
                await MainActor.run {
                    errorLabel.text = "此邀請連結已失效，請請求帳本成員重新產生邀請 QR Code。"
                    errorLabel.alpha = 1
                    titleLabel.alpha = 0
                    ledgerTitleLabel.alpha = 0
                    cancelButton.alpha = 0
                    joinButton.alpha = 0
                }
            }
        }
    }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0

        closeButton.contentMode = .scaleAspectFit
        closeButton.image = UIImage(systemName: "xmark")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))

        titleLabel.text = "帳本名稱"
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        ledgerTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        ledgerTitleLabel.textAlignment = .center
        ledgerTitleLabel.numberOfLines = 0

        cancelButton.configLabel(font: .systemFont(ofSize: 18, weight: .semibold))
        cancelButton.isUserInteractionEnabled = true
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))

        joinButton.configLabel(font: .systemFont(ofSize: 18, weight: .semibold))
        joinButton.isUserInteractionEnabled = true
        joinButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(joinAction)))

        loadingView.alpha = 0

        errorLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0
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

        contentView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        contentView.addSubview(ledgerTitleLabel)
        ledgerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            ledgerTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            ledgerTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: ledgerTitleLabel.bottomAnchor, constant: 24),
            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -48)
        ])

        contentView.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinButton.topAnchor.constraint(equalTo: ledgerTitleLabel.bottomAnchor, constant: 24),
            joinButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 48),
            contentView.bottomAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 24)
        ])

        contentView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: ledgerTitleLabel.bottomAnchor, constant: 24),
            loadingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        contentView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            errorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func closeAction() {
        dismiss(animated: true)
    }

    @objc private func joinAction() {
        loadingView.startAnimating()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            loadingView.alpha = 1
            closeButton.alpha = 0
            joinButton.alpha = 0
            cancelButton.alpha = 0
        }
        Task {
            do {
                let newUserInfoData = try await manager.joinLedger(token: token)
                await MainActor.run {
                    newSharedUserInfo.ledgerIds = newUserInfoData.ledgerIds
                }
                dismiss(animated: true) {
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "成功加入帳本")
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "無法加入帳本")
                await MainActor.run { closeButton.alpha = 1 }
            }
        }
    }
}
