// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

extension TransactionViewController {
    struct CreateData {
        let transaction: TransactionData?
        let ledgerId: String?
        let initialDate: Date?

        init(transaction: TransactionData? = nil, ledgerId: String? = nil, initialDate: Date? = nil) {
            self.transaction = transaction
            self.ledgerId = ledgerId
            self.initialDate = initialDate
        }
    }
}

class TransactionViewController: UIViewController {
    let manager: TransactionManager

    let topLabel = UILabel()
    let cancelLabel = UILabel()
    let saveLabel = UILabel()

    let scrollView = UIScrollView()
    let mainContentView = UIView()

    let titleView = XOTitleWithUnderlineInputView(title: "標題:", placeholder: "可留白")
    let tagSelectView = TTagSelectionButtonView()
    let dateSelectView = TDateSelectionView()
    let incomeExpenseSelectView = TIncomeExpenseSelectorView()
    let amountView = TAmountView()
    let noteLabel = UILabel()
    let noteContextView = UIView()
    let noteTextView = UITextView()

    var noteContentViewBottomConstraint: NSLayoutConstraint?
    var scrollToNoteTextView = false

    init(_ data: CreateData) {
        manager = TransactionManager(transactionData: data.transaction, initialDate: data.initialDate)
        if let ledgerId = data.ledgerId { manager.transactionData.ledgerId = ledgerId }
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        manager.delegate = self
        manager.vc = self
        view.backgroundColor = .white
        addTapBackgroundDismissKeyboard()

        topLabel.text = "帳目資訊"
        topLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        topLabel.textColor = .black
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 1

        cancelLabel.text = "取消"
        cancelLabel.font = .systemFont(ofSize: 16)
        cancelLabel.textColor = .systemRed
        cancelLabel.numberOfLines = 1
        cancelLabel.isUserInteractionEnabled = true
        cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelAction)))

        saveLabel.text = "保存"
        saveLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        saveLabel.textColor = .systemBlue
        saveLabel.numberOfLines = 1
        saveLabel.isUserInteractionEnabled = true
        saveLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSaveAction)))

        scrollView.keyboardDismissMode = .interactive

        titleView.delegate = manager
        titleView.setTitleText(manager.oldTransactionData?.title ?? "")

        tagSelectView.isUserInteractionEnabled = true
        tagSelectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTagSelectAction)))

        dateSelectView.config(date: manager.transactionData.date)
        dateSelectView.delegate = manager

        incomeExpenseSelectView.delegate = manager
        incomeExpenseSelectView.config(type: manager.transactionData.type)

        amountView.config(manager.transactionData.money)
        amountView.delegate = manager

        noteLabel.text = "備註"
        noteLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        noteLabel.numberOfLines = 1
        noteLabel.textAlignment = .left

        noteContextView.layer.cornerRadius = 15.0
        noteContextView.layer.borderWidth = 1.5
        noteContextView.layer.borderColor = UIColor.black.cgColor

        noteTextView.font = .systemFont(ofSize: 16, weight: .semibold)
        noteTextView.textColor = .black
        noteTextView.delegate = self
        noteTextView.text = manager.oldTransactionData?.note ?? ""
    }

    private func layout() {
        view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(cancelLabel)
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelLabel.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor)
        ])

        view.addSubview(saveLabel)
        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveLabel.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor)
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let mainContentViewHeightConstraint = mainContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        mainContentViewHeightConstraint.priority = .defaultLow
        mainContentViewHeightConstraint.isActive = true

        mainContentView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            titleView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24)
        ])

        mainContentView.addSubview(tagSelectView)
        tagSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagSelectView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            tagSelectView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            tagSelectView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24)
        ])

        mainContentView.addSubview(dateSelectView)
        dateSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateSelectView.topAnchor.constraint(equalTo: tagSelectView.bottomAnchor, constant: 24),
            dateSelectView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            dateSelectView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24)
        ])

        mainContentView.addSubview(incomeExpenseSelectView)
        incomeExpenseSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeExpenseSelectView.topAnchor.constraint(equalTo: dateSelectView.bottomAnchor, constant: 24),
            incomeExpenseSelectView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            incomeExpenseSelectView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24)
        ])

        mainContentView.addSubview(amountView)
        amountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountView.topAnchor.constraint(equalTo: incomeExpenseSelectView.bottomAnchor, constant: 24),
            amountView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            amountView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24)
        ])

        mainContentView.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            noteLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            noteLabel.topAnchor.constraint(equalTo: amountView.bottomAnchor, constant: 24),
            noteLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

        mainContentView.addSubview(noteContextView)
        noteContextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteContextView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 8),
            noteContextView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            noteContextView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -24),
            noteContextView.heightAnchor.constraint(equalToConstant: 300)
        ])
        noteContentViewBottomConstraint = noteContextView.bottomAnchor.constraint(equalTo: mainContentView.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        noteContentViewBottomConstraint?.isActive = true

        noteContextView.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: noteContextView.leadingAnchor, constant: 12),
            noteTextView.topAnchor.constraint(equalTo: noteContextView.topAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: noteContextView.trailingAnchor, constant: -12),
            noteTextView.bottomAnchor.constraint(equalTo: noteContextView.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - Utility
extension TransactionViewController {
    @objc private func tapCancelAction() {
        dismiss(animated: true)
    }

    @objc private func tapSaveAction() {
        Task {
            if let message = await manager.saveTransasction() {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: message)
            } else {
                await MainActor.run { dismiss(animated: true) }
            }
        }
    }
}

// MARK: - Tag
extension TransactionViewController: TagViewControllerDelegate {
    @objc private func tapTagSelectAction() {
        let tagVC = TagViewController(type: .selectTag, ledgerId: manager.transactionData.ledgerId)
        tagVC.delegate = self
        let _70DetentId = UISheetPresentationController.Detent.Identifier("70")
        let _70Detent = UISheetPresentationController.Detent.custom(identifier: _70DetentId) { context in
            UIScreen.main.bounds.height * 0.7
        }
        if let sheet = tagVC.sheetPresentationController {
            sheet.detents = [_70Detent]
        }
        present(tagVC, animated: true)
    }

    func selectedTag(vc: UIViewController, data: TagData) {
        manager.tagData = data
        manager.transactionData.tagId = data._id
        DispatchQueue.main.async { [weak self] in
            self?.tagSelectView.config(tag: data)
        }
        vc.dismiss(animated: true)
    }
}

// MARK: - TransactionManagerDelegate
extension TransactionViewController: TransactionManagerDelegate {
    func updateTagInformation(tag: TagData) {
        tagSelectView.config(tag: tag)
    }
}

// MARK: - UITextViewDelegate
extension TransactionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollToNoteTextView = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        manager.transactionData.note = noteTextView.text
    }
}

// MARK: - Keyboard
extension TransactionViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else{ return }
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            if scrollToNoteTextView {
                if let targetRect = noteTextView.superview?.convert(noteTextView.frame, to: scrollView) {
                    scrollView.scrollRectToVisible(targetRect, animated: true)
                }
                scrollToNoteTextView = false
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
