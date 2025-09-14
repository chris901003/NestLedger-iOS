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

    let scrollView = UIScrollView()
    let contentView = UIView()
    let subjectView: LSTSubjectView
    let dateSelectView: LSTDateSelectView
    let amountView: LSTAmountView
    let splitView: LSTSplitView

    let ledgerSplitStore: LedgerSplitDetailStore
    let transactionStore = LSTransactionStore()

    init(ledgerSplitStore: LedgerSplitDetailStore) {
        self.ledgerSplitStore = ledgerSplitStore
        self.subjectView = LSTSubjectView(transactionStore: transactionStore)
        self.dateSelectView = LSTDateSelectView(transactionStore: transactionStore)
        self.amountView = LSTAmountView(transactionStore: transactionStore)
        self.splitView = LSTSplitView(ledgerSplitData: ledgerSplitStore.data, transactionStore: transactionStore)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false

        titleLabel.text = "分帳本帳目"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        splitView.vc = self
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

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let constraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        constraint.priority = .defaultLow
        constraint.isActive = true

        contentView.addSubview(subjectView)
        subjectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subjectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subjectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subjectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(dateSelectView)
        dateSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateSelectView.topAnchor.constraint(equalTo: subjectView.bottomAnchor, constant: 24),
            dateSelectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            dateSelectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(amountView)
        amountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountView.topAnchor.constraint(equalTo: dateSelectView.bottomAnchor, constant: 24),
            amountView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            amountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(splitView)
        splitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splitView.topAnchor.constraint(equalTo: amountView.bottomAnchor, constant: 24),
            splitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            splitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            splitView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
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

// MARK: - Keyboard
extension LSTransactionViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = keyboardHeight
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
