// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/9.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LSTransactionViewController: UIViewController {
    let titleLabel = UILabel()
    let cancelButton = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "xmark")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    )
    let sendButton = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "paperplane")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    )
    let subjectView = LSTSubjectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderWidth = 1.5
        cancelButton.layer.borderColor = UIColor.systemRed.cgColor
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelButtonAction)))
        cancelButton.isUserInteractionEnabled = true

        sendButton.layer.cornerRadius = 15
        sendButton.layer.borderWidth = 1.5
        sendButton.layer.borderColor = UIColor.systemBlue.cgColor
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSendButtonAction)))
        sendButton.isUserInteractionEnabled = true

        titleLabel.text = "分帳本帳目"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    private func layout() {
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor)
        ])

        view.addSubview(subjectView)
        subjectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subjectView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            subjectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subjectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

// MARK: - Utility
extension LSTransactionViewController {
    @objc private func tapCancelButtonAction() {
        dismiss(animated: true)
    }

    @objc private func tapSendButtonAction() {
        print("✅ Tap send button action")
        subjectView.bottomLine.fillLeftToRight(duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.subjectView.bottomLine.clearLeftToRight(duration: 0.5)
        }
//        dismiss(animated: true)
    }
}
