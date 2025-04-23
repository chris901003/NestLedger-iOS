// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LDSLMEnterNewMemberDelegate: AnyObject {
    func sendLedgerInvite(address: String)
}

class LDSLMEnterNewMemberViewController: UIViewController {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let titleLabel = UILabel()
    let textField = XOTextField(.init(top: 12, left: 12, bottom: 12, right: 12))
    let cancelButton = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    )
    let addButton = XOPaddedImageView(
        padding: .init(top: 8, left: 8, bottom: 8, right: 8),
        image: UIImage(systemName: "checkmark")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    )

    weak var delegate: LDSLMEnterNewMemberDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 15.0

        titleLabel.text = "邀請使用者"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1

        textField.placeholder = "輸入使用者電子郵件"
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10.0
        textField.clipsToBounds = true
        textField.delegate = self

        cancelButton.layer.cornerRadius = 15.0
        cancelButton.layer.borderWidth = 1.5
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.clipsToBounds = true
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelAction)))
        cancelButton.isUserInteractionEnabled = true

        addButton.layer.cornerRadius = 15.0
        addButton.layer.borderWidth = 1.5
        addButton.layer.borderColor = UIColor.systemBlue.cgColor
        addButton.clipsToBounds = true
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSendAction)))
        addButton.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 350)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
        ])

        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -66),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 66),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    @objc private func tapCancelAction() {
        dismiss(animated: true)
    }

    @objc private func tapSendAction() {
        delegate?.sendLedgerInvite(address: textField.text ?? "")
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LDSLMEnterNewMemberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
