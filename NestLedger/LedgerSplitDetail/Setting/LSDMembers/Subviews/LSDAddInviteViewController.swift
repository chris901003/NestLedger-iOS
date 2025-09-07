// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LSDAddInviteViewControllerDelegate: AnyObject {
    func newLedgerSplitUserInvite(data: LedgerSplitUserInviteData)
}

class LSDAddInviteViewController: UIViewController {
    let titleLabel = UILabel()
    let emailAddressLabel = UILabel()
    let emailAddressInputView = XOTextField(.init(top: 8, left: 12, bottom: 8, right: 12))
    let cancelButton = XOPaddedImageView(
        padding: .init(top: 12, left: 12, bottom: 12, right: 12),
        image: UIImage(systemName: "xmark")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    )
    let addButton = XOPaddedImageView(
        padding: .init(top: 12, left: 12, bottom: 12, right: 12),
        image: UIImage(systemName: "paperplane")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    )

    let ledgerSplitStore: LedgerSplitDetailStore
    weak var delegate: LSDAddInviteViewControllerDelegate?

    init(ledgerSplitStore: LedgerSplitDetailStore) {
        self.ledgerSplitStore = ledgerSplitStore
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
        view.backgroundColor = .white

        titleLabel.text = "邀請加入分帳本"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        emailAddressLabel.text = "輸入對方電子郵件"
        emailAddressLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        emailAddressLabel.textColor = .secondaryLabel

        emailAddressInputView.placeholder = "輸入對方電子郵件"
        emailAddressInputView.font = .systemFont(ofSize: 16, weight: .semibold)
        emailAddressInputView.layer.cornerRadius = 10.0
        emailAddressInputView.layer.borderWidth = 1.5
        emailAddressInputView.layer.borderColor = UIColor.systemGray4.cgColor
        emailAddressInputView.keyboardType = .emailAddress
        emailAddressInputView.returnKeyType = .done
        emailAddressInputView.delegate = self

        cancelButton.layer.cornerRadius = 45.0 / 2
        cancelButton.layer.borderWidth = 2.0
        cancelButton.layer.borderColor = UIColor.systemRed.cgColor
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelAction)))
        cancelButton.isUserInteractionEnabled = true

        addButton.layer.cornerRadius = 45.0 / 2
        addButton.layer.borderWidth = 2.0
        addButton.layer.borderColor = UIColor.systemBlue.cgColor
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddAction)))
        addButton.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            emailAddressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])

        view.addSubview(emailAddressInputView)
        emailAddressInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressInputView.leadingAnchor.constraint(equalTo: emailAddressLabel.leadingAnchor),
            emailAddressInputView.topAnchor.constraint(equalTo: emailAddressLabel.bottomAnchor, constant: 8),
            emailAddressInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: emailAddressInputView.bottomAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -24),
            cancelButton.widthAnchor.constraint(equalToConstant: 45),
            cancelButton.heightAnchor.constraint(equalToConstant: 45)
        ])

        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: emailAddressInputView.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 24),
            addButton.widthAnchor.constraint(equalToConstant: 45),
            addButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LSDAddInviteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Utility
extension LSDAddInviteViewController {
    @objc private func tapCancelAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func tapAddAction() {
        view.endEditing(true)

        let newAPIManager = NewAPIManager()
        Task {
            do {
                let inviteUserInfo = try await newAPIManager.getUserByEmail(emailAddress: emailAddressInputView.text ?? "")
                let userInviteData = try await newAPIManager.ledgerSplitCreateUserInvite(
                    data: .init(ledgerSplitId: ledgerSplitStore.data._id, receiveUserId: inviteUserInfo.id)
                )
                delegate?.newLedgerSplitUserInvite(data: userInviteData)
                navigationController?.popViewController(animated: true)
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "發送邀請失敗")
            }
        }
    }
}
