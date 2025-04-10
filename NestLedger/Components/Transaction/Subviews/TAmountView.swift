// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

fileprivate class AddAmountView: UIView {
    let label = UILabel()

    init(_ text: String) {
        super.init(frame: .zero)
        setup(text)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(_ text: String) {
        backgroundColor = .systemBlue.withAlphaComponent(0.2)
        layer.cornerRadius = 10.0

        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.textAlignment = .center
    }

    private func layout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

protocol TAmountViewDelegate: AnyObject {
    func updateAmount(amount: Int)
}

class TAmountView: UIView {
    fileprivate let addButton1 = AddAmountView("+1")
    fileprivate let addButton10 = AddAmountView("+10")
    fileprivate let addButton100 = AddAmountView("+100")
    fileprivate let addButton1000 = AddAmountView("+1000")
    var addButtonWidthConstraints: [NSLayoutConstraint?] = []

    let amountTitleLabel = UILabel()
    let amountTextField = UITextField()

    var amount: Int = 0 {
        didSet { delegate?.updateAmount(amount: amount) }
    }
    weak var delegate: TAmountViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let addButtonWidth = (bounds.width - 12 * 3) / 4
        for widthConstraint in addButtonWidthConstraints {
            widthConstraint?.constant = addButtonWidth
        }
    }

    func config(_ amount: Int) {
        self.amount = amount
        amountTextField.text = "\(amount)"
    }

    private func setup() {
        setupAddButton()

        amountTitleLabel.text = "金額:"
        amountTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountTitleLabel.numberOfLines = 1

        amountTextField.text = "\(amount)"
        amountTextField.font = .systemFont(ofSize: 16, weight: .semibold)
        amountTextField.keyboardType = .numberPad
        amountTextField.textAlignment = .right
        amountTextField.delegate = self
    }

    private func setupAddButton() {
        addButton1.tag = 1
        addButton1.isUserInteractionEnabled = true
        addButton1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonAction)))
        addButton10.tag = 10
        addButton10.isUserInteractionEnabled = true
        addButton10.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonAction)))
        addButton100.tag = 100
        addButton100.isUserInteractionEnabled = true
        addButton100.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonAction)))
        addButton1000.tag = 1000
        addButton1000.isUserInteractionEnabled = true
        addButton1000.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonAction)))
    }

    private func layout() {
        layoutAddButton(addButton: addButton1)
        addButton1.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        layoutAddButton(addButton: addButton10)
        addButton10.leadingAnchor.constraint(equalTo: addButton1.trailingAnchor, constant: 12).isActive = true
        layoutAddButton(addButton: addButton100)
        addButton100.leadingAnchor.constraint(equalTo: addButton10.trailingAnchor, constant: 12).isActive = true
        layoutAddButton(addButton: addButton1000)
        addButton1000.leadingAnchor.constraint(equalTo: addButton100.trailingAnchor, constant: 12).isActive = true

        addSubview(amountTitleLabel)
        amountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountTitleLabel.topAnchor.constraint(equalTo: addButton1.bottomAnchor, constant: 24),
            amountTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        amountTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        addSubview(amountTextField)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountTextField.leadingAnchor.constraint(equalTo: amountTitleLabel.trailingAnchor),
            amountTextField.centerYAnchor.constraint(equalTo: amountTitleLabel.centerYAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        amountTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func layoutAddButton(addButton: UIView) {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        let widthConstraint = addButton.widthAnchor.constraint(equalToConstant: 60)
        widthConstraint.isActive = true
        addButtonWidthConstraints.append(widthConstraint)
    }
}

extension TAmountView {
    @objc private func addButtonAction(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        amountTextField.resignFirstResponder()
        amount += tappedView.tag
        amountTextField.text = "\(amount)"
    }
}

extension TAmountView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        amount = Int(textField.text ?? "0") ?? 0
    }
}
