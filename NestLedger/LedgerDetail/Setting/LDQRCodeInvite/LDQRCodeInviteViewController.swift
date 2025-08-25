// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDQRCodeInviteViewController: UIViewController {
    let ledgerData: LedgerData
    let newApiManager = NewAPIManager()

    let infoLabel = UILabel()

    let loadingView = UIActivityIndicatorView(style: .medium)
    let qrcodeView = UIImageView()
    let errorLabel = UILabel()

    init(ledgerData: LedgerData) {
        self.ledgerData = ledgerData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCommon()

        if ledgerData.title.hasPrefix("[Main]") {
            setupBlock()
            layoutBlock()
        } else {
            setup()
            layout()
        }
    }

    private func setupCommon() {
        navigationItem.title = "加入帳本 QR Code"
        view.backgroundColor = .white
    }
}

// MARK: - Block
extension LDQRCodeInviteViewController {
    private func setupBlock() {
        infoLabel.text = "主帳本僅限個人使用，如需與他人共享，請建立新的帳本。"
        infoLabel.textColor = .secondaryLabel
        infoLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
    }

    private func layoutBlock() {
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

// MARK: - Non Block
extension LDQRCodeInviteViewController {
    private func setup() {
        loadingView.startAnimating()

        qrcodeView.contentMode = .scaleAspectFit
        qrcodeView.alpha = 0

        errorLabel.textColor = .secondaryLabel
        errorLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 0

        createInviteLink()
    }

    private func layout() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(qrcodeView)
        qrcodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrcodeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrcodeView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createInviteLink() {
        Task {
            do {
                let data = try await newApiManager.createLedgerInviteLink(ledgerId: ledgerData._id)
                guard let qrcode = QRCodeGenerator.generateQRCode(str: data.link) else {
                    throw BasicError.common(msg: "無法生成 QR Code")
                }
                await MainActor.run {
                    qrcodeView.image = qrcode
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let self else { return }
                        qrcodeView.alpha = 1
                        loadingView.alpha = 0
                    }
                    loadingView.stopAnimating()
                }
            } catch {
                await MainActor.run {
                    errorLabel.text = error.localizedDescription
                    errorLabel.alpha = 1
                    loadingView.alpha = 0
                    loadingView.stopAnimating()
                }
            }
        }
    }
}
