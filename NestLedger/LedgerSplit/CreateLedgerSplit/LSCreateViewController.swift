// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LSCreateViewControllerDelegate: AnyObject {
    func createNewLedgerSplit(data: LedgerSplitData, avatar: UIImage?)
}

class LSCreateViewController: UIViewController {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let titleLabel = UILabel()
    let ledgerAvatarView = LSCLedgerAvatarView()
    let titleTextField = XOTextField(.init(top: 8, left: 16, bottom: 8, right: 16))
    let cancelButton = LSCButtonView()
    let createButton = LSCButtonView()

    let manager = LSCreateManager()
    weak var delegate: LSCreateViewControllerDelegate?
    var contentHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundAction)))
        blurView.isUserInteractionEnabled = true

        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10.0

        titleLabel.text = "創建分帳本"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        titleTextField.placeholder = "分帳本名稱"
        titleTextField.backgroundColor = .systemBackground
        titleTextField.layer.cornerRadius = 10.0
        titleTextField.delegate = self

        ledgerAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAvatarAction)))
        ledgerAvatarView.isUserInteractionEnabled = true

        cancelButton.config(title: "取消", color: .systemRed)
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelAction)))
        cancelButton.isUserInteractionEnabled = true

        createButton.config(title: "創建", color: .systemBlue)
        createButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCreateAction)))
        createButton.isUserInteractionEnabled = true
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
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 3 / 4)
        ])
        contentHeightConstraint = contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        contentHeightConstraint.isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        contentView.addSubview(ledgerAvatarView)
        ledgerAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerAvatarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            ledgerAvatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        contentView.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: ledgerAvatarView.bottomAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -24)
        ])

        contentView.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            createButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 24),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Utility
extension LSCreateViewController {
    @objc private func tapBackgroundAction() {
        dismiss(animated: true)
    }

    @objc private func tapCancelAction() {
        dismiss(animated: true)
    }

    @objc private func tapCreateAction() {
        manager.ledgerSplitData.title = titleTextField.text ?? ""
        Task {
            if let message = await manager.createLedgerSplit() {
                let okAction = UIAlertAction(title: "確定", style: .cancel)
                let alertController = UIAlertController(title: "創建分帳本失敗", message: message, preferredStyle: .alert)
                alertController.addAction(okAction)
                present(alertController, animated: true)
            } else {
                delegate?.createNewLedgerSplit(data: manager.ledgerSplitData, avatar: manager.ledgerAvatar)
                dismiss(animated: true)
            }
        }
    }

    @objc private func tapAvatarAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LSCreateViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        contentHeightConstraint.constant = -60
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        contentHeightConstraint.constant = 0
        manager.ledgerSplitData.title = textField.text ?? ""
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension LSCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            ledgerAvatarView.config(avatar: image)
            manager.ledgerAvatar = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
