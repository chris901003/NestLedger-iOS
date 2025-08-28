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
    let sendButton = XOPaddedImageView(
        padding: .init(top: 6, left: 6, bottom: 6, right: 6),
        image: UIImage(systemName: "paperplane")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    )
    let scrollView = UIScrollView()
    let mainContentView = UIView()
    let titleLable = UILabel()
    let titleInputView = XOTextField(.init(top: 8, left: 16, bottom: 8, right: 16))
    let emailAddressLabel = UILabel()
    let emailAddressInputView = XOTextField(.init(top: 8, left: 16, bottom: 8, right: 16))
    let contentLabel = UILabel()
    let contentInputView = UITextView()
    let bottomView = UIView()

    let manager = FeedbackManager()
    var bottomViewHeightConstraint: NSLayoutConstraint!
    var allowDismiss = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setup() {
        presentationController?.delegate = self
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundAction)))
        view.isUserInteractionEnabled = true

        scrollView.keyboardDismissMode = .onDrag

        topBarView.backgroundColor = .systemGray5
        topBarView.layer.cornerRadius = 2.0

        sendButton.layer.cornerRadius = 30 / 2
        sendButton.layer.borderWidth = 1.5
        sendButton.layer.borderColor = UIColor.systemBlue.cgColor
        sendButton.isUserInteractionEnabled = true
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendAction)))

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

        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        mainContentView.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            titleLable.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24)
        ])

        mainContentView.addSubview(titleInputView)
        titleInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleInputView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 6),
            titleInputView.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor, constant: 12),
            titleInputView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24)
        ])

        mainContentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor)
        ])
        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: 0)
        bottomViewHeightConstraint.isActive = true

        mainContentView.addSubview(emailAddressInputView)
        emailAddressInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressInputView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            emailAddressInputView.leadingAnchor.constraint(equalTo: titleInputView.leadingAnchor),
            emailAddressInputView.trailingAnchor.constraint(equalTo: titleInputView.trailingAnchor)
        ])

        mainContentView.addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailAddressLabel.bottomAnchor.constraint(equalTo: emailAddressInputView.topAnchor, constant: -6),
            emailAddressLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor)
        ])

        mainContentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleInputView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor)
        ])

        mainContentView.addSubview(contentInputView)
        contentInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentInputView.leadingAnchor.constraint(equalTo: titleInputView.leadingAnchor),
            contentInputView.trailingAnchor.constraint(equalTo: titleInputView.trailingAnchor),
            contentInputView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 6),
            contentInputView.bottomAnchor.constraint(equalTo: emailAddressLabel.topAnchor, constant: -12)
        ])
    }

    @objc private func tapBackgroundAction() {
        view.endEditing(true)
    }

    @objc private func sendAction() {
        Task {
            await manager.sendFeedback()
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension FeedbackViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return allowDismiss
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "要關閉嗎？", message: "資料將會遺失", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "確定關閉", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.allowDismiss = true
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - Keyboard
extension FeedbackViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: duration) {
            self.bottomViewHeightConstraint.constant = keyboardHeight
            self.scrollView.contentInset.bottom = keyboardHeight
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.bottomViewHeightConstraint.constant = 0
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
