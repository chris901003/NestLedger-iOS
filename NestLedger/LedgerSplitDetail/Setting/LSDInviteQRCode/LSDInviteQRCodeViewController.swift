// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LSDInviteQRCodeViewController: UIViewController {
    let ledgerSplitData: LedgerSplitData
    let newAPIManager = NewAPIManager()
    let countdownLabel = NLCountdownLabel()

    let imageView = UIImageView()
    let loadingView = UIActivityIndicatorView(style: .medium)

    init(ledgerSplitData: LedgerSplitData) {
        self.ledgerSplitData = ledgerSplitData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        navigationItem.title = "加入分帳本 QRCode"

        view.backgroundColor = .white

        loadingView.startAnimating()

        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0

        countdownLabel.textColor = .secondaryLabel
        countdownLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        countdownLabel.textAlignment = .center
        countdownLabel.numberOfLines = 1
        countdownLabel.alpha = 0

        createInviteLink()
    }

    private func layout() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            countdownLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            countdownLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

private extension LSDInviteQRCodeViewController {
    func createInviteLink() {
        Task {
            do {
                let data = try await newAPIManager.ledgerSplitInviteCreateLink(ledgerSplitId: ledgerSplitData._id)
                let image = QRCodeGenerator.generateQRCode(str: data.link)
                countdownLabel.startCountdown(to: data.expireAt)
                await MainActor.run {
                    loadingView.stopAnimating()
                    loadingView.alpha = 0
                    imageView.image = image
                    imageView.alpha = 1
                    countdownLabel.alpha = 1
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "創建連結失敗，請稍後再嘗試。")
            }
        }
    }
}
