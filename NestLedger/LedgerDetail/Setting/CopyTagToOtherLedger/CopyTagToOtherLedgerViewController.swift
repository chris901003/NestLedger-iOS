// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/11.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CopyTagToOtherLedgerViewController: UIViewController {
    let backButtonView = LDSCTBackButtonView()
    let titleLabel = UILabel()
    let copyButton = UILabel()
    let ledgerSelectView = LDSCTTargetLedgerSelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        backButtonView.isUserInteractionEnabled = true
        backButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackAction)))

        titleLabel.text = "複製標籤到其他帳本"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        copyButton.text = "複製"
        copyButton.font = .systemFont(ofSize: 16, weight: .semibold)
        copyButton.textColor = .tintColor

        ledgerSelectView.isUserInteractionEnabled = true
        ledgerSelectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSelectLedgerAction)))
    }

    private func layout() {
        view.addSubview(backButtonView)
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            backButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(copyButton)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            copyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            copyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])

        view.addSubview(ledgerSelectView)
        ledgerSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerSelectView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            ledgerSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ledgerSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

// MARK: - Tap Action
extension CopyTagToOtherLedgerViewController {
    @objc private func tapBackAction() {
        dismiss(animated: true)
    }

    @objc private func tapSelectLedgerAction() {
        let ledgerListVC = LDSCTLedgerListViewController()
        let _50DetentId = UISheetPresentationController.Detent.Identifier("50")
        let _50Detent = UISheetPresentationController.Detent.custom(identifier: _50DetentId) { context in
            UIScreen.main.bounds.height * 0.5
        }
        if let sheet = ledgerListVC.sheetPresentationController {
            sheet.detents = [_50Detent]
        }
        present(ledgerListVC, animated: true)
    }
}
