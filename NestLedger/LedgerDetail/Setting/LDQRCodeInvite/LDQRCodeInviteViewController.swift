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

    let infoLabel = UILabel()
    let loadingView = UIActivityIndicatorView(style: .medium)
    let qrcodeView = UIImageView()

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

        Task {
            let qrcode = QRCodeGenerator.generateQRCode(str: "https://xxooooxx.org")
            await MainActor.run {
                if let qrcode {
                    qrcodeView.image = qrcode
                    qrcodeView.alpha = 1
                    loadingView.alpha = 0
                    loadingView.stopAnimating()
                }
            }
            
        }
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
    }
}
