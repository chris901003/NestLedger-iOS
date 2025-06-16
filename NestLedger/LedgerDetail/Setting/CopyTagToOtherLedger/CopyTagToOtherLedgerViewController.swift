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
    let targetTagView = LDSCTTargetTagView()
    let currentTagView = LDSCTTargetTagView()

    var targetTagViewHeightConstraint: NSLayoutConstraint!

    let manager: CopyTagToOtherLedgerManager

    init(ledgerId: String) {
        manager = CopyTagToOtherLedgerManager(ledgerId: ledgerId)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let remainHeight = view.bounds.height - (ledgerSelectView.frame.origin.y + ledgerSelectView.bounds.height) - 24 - 24 - 36
        targetTagViewHeightConstraint.constant = remainHeight / 2
    }

    private func setup() {
        manager.vc = self
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

        targetTagView.delegate = manager
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

        view.addSubview(targetTagView)
        targetTagView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetTagView.topAnchor.constraint(equalTo: ledgerSelectView.bottomAnchor, constant: 24),
            targetTagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            targetTagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        targetTagViewHeightConstraint = targetTagView.heightAnchor.constraint(equalToConstant: 200)
        targetTagViewHeightConstraint.isActive = true

        view.addSubview(currentTagView)
        currentTagView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentTagView.topAnchor.constraint(equalTo: targetTagView.bottomAnchor, constant: 24),
            currentTagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            currentTagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            currentTagView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36)
        ])
    }
}

// MARK: - Tap Action
extension CopyTagToOtherLedgerViewController: LDSCTLedgerListViewControllerDelegate {
    @objc private func tapBackAction() {
        dismiss(animated: true)
    }

    @objc private func tapSelectLedgerAction() {
        let ledgerListVC = LDSCTLedgerListViewController()
        ledgerListVC.delegate = self
        let _50DetentId = UISheetPresentationController.Detent.Identifier("50")
        let _50Detent = UISheetPresentationController.Detent.custom(identifier: _50DetentId) { context in
            UIScreen.main.bounds.height * 0.5
        }
        if let sheet = ledgerListVC.sheetPresentationController {
            sheet.detents = [_50Detent]
        }
        present(ledgerListVC, animated: true)
    }

    func didSelect(ledgerData: LedgerData) {
        manager.targetLedgerId = ledgerData._id
        DispatchQueue.main.async { [weak self] in
            self?.ledgerSelectView.targetLedgerLabel.text = ledgerData.titleShow
        }
    }
}
