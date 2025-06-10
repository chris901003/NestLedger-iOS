// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/10.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol MQLTitleInputViewDelegate: AnyObject {
    func titleInputViewDidChange(title: String)
}

class MQLTitleInputView: UIView {
    let leftView = UIView()
    let iconImageView = UIImageView()
    let titleInputView = UITextField()

    weak var delegate: MQLTitleInputViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layuout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 20.0
        layer.borderWidth = 2.5
        layer.borderColor = UIColor(hexCode: "#8CCDEB").withAlphaComponent(0.5).cgColor
        clipsToBounds = true

        leftView.backgroundColor = UIColor(hexCode: "#8CCDEB").withAlphaComponent(0.5)

        iconImageView.image = UIImage(systemName: "square.and.pencil")?.withTintColor(UIColor(hexCode: "#8CCDEB"), renderingMode: .alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit

        titleInputView.placeholder = "標題名稱 (可選)"
        titleInputView.font = .systemFont(ofSize: 16, weight: .semibold)
        titleInputView.textAlignment = .left
        titleInputView.delegate = self
    }

    private func layuout() {
        addSubview(leftView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftView.topAnchor.constraint(equalTo: topAnchor),
            leftView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftView.widthAnchor.constraint(equalToConstant: 50)
        ])

        leftView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -8),
            iconImageView.topAnchor.constraint(equalTo: leftView.topAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor, constant: -8),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])

        addSubview(titleInputView)
        titleInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleInputView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 12),
            titleInputView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleInputView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension MQLTitleInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.titleInputViewDidChange(title: textField.text ?? "")
    }
}
