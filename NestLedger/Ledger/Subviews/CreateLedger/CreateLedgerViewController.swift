// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/29.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol CreateLedgerViewControllerDelegate: AnyObject {
    func createLedger(title: String)
}

class CreateLedgerViewController: UIViewController {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let titleLabel = UILabel()
    let textField = XOTextField(.init(top: 12, left: 16, bottom: 12, right: 12))
    let cancelView = XOBorderLabel("取消", color: .systemPink, padding: .init(top: 10, left: 16, bottom: 10, right: 16))
    let createView = XOBorderLabel("創建", color: .systemBlue, padding: .init(top: 10, left: 16, bottom: 10, right: 16))

    weak var delegate: CreateLedgerViewControllerDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundViewAction)))
        blurView.isUserInteractionEnabled = true

        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 10.0

        titleLabel.text = "創建新帳本"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        textField.placeholder = "輸入帳本名稱"
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.delegate = self

        cancelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelAction)))
        cancelView.isUserInteractionEnabled = true

        createView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createAction)))
        createView.isUserInteractionEnabled = true
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

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(cancelView)
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            cancelView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -24)
        ])

        contentView.addSubview(createView)
        createView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            createView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 24),
            createView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    @objc private func tapBackgroundViewAction() {
        dismiss(animated: true)
    }

    @objc private func cancelAction() {
        dismiss(animated: true)
    }

    @objc private func createAction() {
        delegate?.createLedger(title: textField.text ?? "")
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension CreateLedgerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
