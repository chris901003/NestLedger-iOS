// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class TransactionViewController: UIViewController {
    let manager: TransactionManager

    let topLabel = UILabel()
    let cancelLabel = UILabel()
    let saveLabel = UILabel()
    let titleView = XOTitleWithUnderlineInputView(title: "標題:", placeholder: "可留白")
    let tagSelectView = TTagSelectionButtonView()
    let dateSelectView = TDateSelectionView()
    let incomeExpenseSelectView = TIncomeExpenseSelectorView()

    init(transaction: TransactionData? = nil) {
        manager = TransactionManager(transactionData: transaction)
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
        manager.delegate = self
        view.backgroundColor = .white

        topLabel.text = "帳目資訊"
        topLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        topLabel.textColor = .black
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 1

        cancelLabel.text = "取消"
        cancelLabel.font = .systemFont(ofSize: 16)
        cancelLabel.textColor = .systemRed
        cancelLabel.numberOfLines = 1

        saveLabel.text = "保存"
        saveLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        saveLabel.textColor = .systemBlue
        saveLabel.numberOfLines = 1

        titleView.delegate = manager

        tagSelectView.isUserInteractionEnabled = true
        tagSelectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTagSelectAction)))

        dateSelectView.config(date: manager.transactionData.date)
        dateSelectView.delegate = manager

        incomeExpenseSelectView.delegate = manager
        incomeExpenseSelectView.config(type: manager.transactionData.type)
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

        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 24),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(tagSelectView)
        tagSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagSelectView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24),
            tagSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tagSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(dateSelectView)
        dateSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateSelectView.topAnchor.constraint(equalTo: tagSelectView.bottomAnchor, constant: 24),
            dateSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dateSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(incomeExpenseSelectView)
        incomeExpenseSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeExpenseSelectView.topAnchor.constraint(equalTo: dateSelectView.bottomAnchor, constant: 24),
            incomeExpenseSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            incomeExpenseSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

// MARK: - Tag
extension TransactionViewController: TagViewControllerDelegate {
    @objc private func tapTagSelectAction() {
        let tagVC = TagViewController(type: .selectTag)
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
