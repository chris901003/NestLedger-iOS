// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class FeedbackViewController: UIViewController {
    let topBarView = UIView()
    let titleLable = UILabel()
    let titleInputView = XOTextField(.init(top: 8, left: 16, bottom: 8, right: 16))
    let emailAddressLabel = UILabel()
    let emailAddressInputView = XOTextField(.init(top: 8, left: 16, bottom: 8, right: 16))
    let contentLabel = UILabel()
    let contentInputView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        topBarView.backgroundColor = .systemGray5
        topBarView.layer.cornerRadius = 2.0

        setupLabel(label: titleLable, title: "你想回饋的主題")
        setupInputView(inputView: titleInputView, placeholder: "請輸入想回饋的主題")

        setupLabel(label: contentLabel, title: "告訴我們詳細的想法")
        contentInputView.font = .systemFont(ofSize: 16, weight: .semibold)
        contentInputView.textColor = .black
        contentInputView.layer.borderColor = UIColor.secondaryLabel.cgColor
        contentInputView.layer.cornerRadius = 10.0
        contentInputView.layer.borderWidth = 1.5

        setupLabel(label: emailAddressLabel, title: "方便聯絡你的信箱(可留空)")
        setupInputView(inputView: emailAddressInputView, placeholder: "請輸入方便聯絡你的信箱(可留空)")
    }

    private func setupLabel(label: UILabel, title: String) {
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
    }

    private func setupInputView(inputView: UITextField, placeholder: String) {
        inputView.placeholder = placeholder
        inputView.font = .systemFont(ofSize: 16, weight: .semibold)
        inputView.textColor = .black
        inputView.layer.borderWidth = 1.5
        inputView.layer.cornerRadius = 10.0
        inputView.layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    private func layout() {
        view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBarView.widthAnchor.constraint(equalToConstant: 30),
            topBarView.heightAnchor.constraint(equalToConstant: 4)
        ])

        view.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 24),
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])

        view.addSubview(titleInputView)
        titleInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleInputView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 6),
            titleInputView.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor, constant: 12),
            titleInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(emailAddressInputView)
        emailAddressInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emailAddressInputView.leadingAnchor.constraint(equalTo: titleInputView.leadingAnchor),
            emailAddressInputView.trailingAnchor.constraint(equalTo: titleInputView.trailingAnchor)
        ])

        view.addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressLabel.bottomAnchor.constraint(equalTo: emailAddressInputView.topAnchor, constant: -6),
            emailAddressLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor)
        ])

        view.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleInputView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor)
        ])

        view.addSubview(contentInputView)
        contentInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentInputView.leadingAnchor.constraint(equalTo: titleInputView.leadingAnchor),
            contentInputView.trailingAnchor.constraint(equalTo: titleInputView.trailingAnchor),
            contentInputView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 6),
            contentInputView.bottomAnchor.constraint(equalTo: emailAddressLabel.topAnchor, constant: -12)
        ])
    }
}
