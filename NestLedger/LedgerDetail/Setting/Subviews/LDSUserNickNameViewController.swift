// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/11.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LDSUserNickNameViewControllerDelegate: AnyObject {
    func updateNickName(name: String)
}

class LDSUserNickNameViewController: UIViewController {
    let contentView = UIView()
    let titleLabel = UILabel()
    let nameTextField = UITextField()
    let noteLabel = UILabel()

    weak var delegate: LDSUserNickNameViewControllerDelegate?

    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        setup(initName: userName)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(initName: String) {
        view.backgroundColor = .white
        navigationItem.title = "設定暱稱"

        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15.0

        titleLabel.text = "暱稱"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        nameTextField.placeholder = "請輸入暱稱"
        nameTextField.text = initName
        nameTextField.textAlignment = .right
        nameTextField.font = .systemFont(ofSize: 16, weight: .semibold)
        nameTextField.delegate = self

        noteLabel.text = "您為此帳本設定的暱稱只會用於此帳本，其他帳本中的暱稱將不受影響。"
        noteLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        noteLabel.textColor = .secondaryLabel
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0
    }

    private func layout() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])

        contentView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            nameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        view.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LDSUserNickNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateNickName(name: textField.text ?? "")
    }
}
