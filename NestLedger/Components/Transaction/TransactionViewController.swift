// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/2.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class ExpandingLineView: UIView {

    private let maskLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLine()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLine()
    }
    
    private func setupLine() {
        backgroundColor = .systemGray5
        maskLayer.backgroundColor = UIColor.black.cgColor

        layer.addSublayer(maskLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if maskLayer.frame.height == 0 {
            maskLayer.frame = .init(x: bounds.midX, y: bounds.midY, width: 0, height: 2)
        }
    }

    func startAnimation() {
        let finalWidth = bounds.width
        let finalFrame = CGRect(x: 0, y: 0, width: finalWidth, height: bounds.height)

        maskLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        maskLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        maskLayer.bounds = CGRect(x: 0, y: 0, width: 0, height: bounds.height)

        let widthAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        widthAnimation.fromValue = 0
        widthAnimation.toValue = finalWidth

        widthAnimation.duration = 1.0
        widthAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        maskLayer.bounds.size.width = finalWidth
        maskLayer.add(widthAnimation, forKey: "expand")
    }

    func retractAnimation() {
        let retractAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        retractAnimation.fromValue = bounds.width
        retractAnimation.toValue = 0
        retractAnimation.duration = 1.0
        retractAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        maskLayer.bounds.size.width = 0
        maskLayer.add(retractAnimation, forKey: "retract")
    }
}

class XOTitleWithUnderlineInputView: UIView {
    let titleLabel = UILabel()
    let textField = UITextField()
    let bottomLineView = ExpandingLineView()

    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        setup(title, placeholder)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(_ title: String, _ placeholder: String) {
        titleLabel.text = title
        titleLabel.numberOfLines = 1

        textField.placeholder = placeholder
        textField.textAlignment = .center
        textField.delegate = self
        textField.returnKeyType = .done
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        addSubview(bottomLineView)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        bottomLineView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

extension XOTitleWithUnderlineInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [weak self] in
            self?.bottomLineView.startAnimation()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [weak self] in
            self?.bottomLineView.retractAnimation()
        }
    }
}

class TransactionViewController: UIViewController {
    let manager: TransactionManager

    let topLabel = UILabel()
    let cancelLabel = UILabel()
    let saveLabel = UILabel()
    let titleView = XOTitleWithUnderlineInputView(title: "標題:", placeholder: "可留白")

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
    }
}
