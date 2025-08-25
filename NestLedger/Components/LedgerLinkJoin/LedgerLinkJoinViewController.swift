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
                // TODO: 這裡需要完整的說明，因為是非常有可能到這裡，原因是過期的 token
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
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
    }

    @objc private func closeAction() {
        dismiss(animated: true)
    }

    @objc private func joinAction() {
        print("✅ Join ledger")
    }
}
