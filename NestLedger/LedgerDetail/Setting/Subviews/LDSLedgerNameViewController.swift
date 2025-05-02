// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LDSLedgerNameViewControllerDelegate: AnyObject {
    func updateLedgerName(title: String)
}

class LDSLedgerNameViewController: UIViewController {
    let contentView = UIView()
    let titleLabel = UILabel()
    let textField = UITextField()
    let infoLabel = UILabel()

    weak var delegate: LDSLedgerNameViewControllerDelegate?

    init(title: String, isVariable: Bool) {
        super.init(nibName: nil, bundle: nil)
        setup(title, isVariable)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(_ title: String, _ isVariable: Bool) {
        view.backgroundColor = .white
        navigationItem.title = "編輯帳目名稱"

        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15.0
        contentView.clipsToBounds = true

        titleLabel.text = "帳目名稱:"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1

        textField.text = title
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        textField.textAlignment = .right
        textField.isEnabled = isVariable
        textField.delegate = self

        infoLabel.text = "當此帳本為「預設帳本」時將無法更改帳本名稱"
        infoLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        infoLabel.textColor = .systemGray
        infoLabel.textAlignment = .center
    }

    private func layout() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LDSLedgerNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateLedgerName(title: textField.text ?? "")
    }
}
