// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/9.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LSTSubjectViewDelegate: AnyObject {
    func subjectDidChange(_ text: String)
}

class LSTSubjectView: UIView {
    let titleLabel = UILabel()
    let inputFieldView = UITextField()
    let bottomLine = NLGradientAnimatedLineView()

    weak var delegate: LSTSubjectViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel.text = "標題:"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        inputFieldView.placeholder = "請輸入標題"
        inputFieldView.font = .systemFont(ofSize: 18, weight: .semibold)
        inputFieldView.delegate = self
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        addSubview(inputFieldView)
        inputFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputFieldView.topAnchor.constraint(equalTo: topAnchor),
            inputFieldView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            inputFieldView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: inputFieldView.bottomAnchor, constant: 2),
            bottomLine.leadingAnchor.constraint(equalTo: inputFieldView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: inputFieldView.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension LSTSubjectView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        bottomLine.clearLeftToRight()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        bottomLine.fillLeftToRight()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.subjectDidChange(textField.text ?? "")
    }
}
