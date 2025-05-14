// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol TagEditViewControllerDelegate: AnyObject {
    func updateTag(data: TagData, indexPath: IndexPath?)
}

class TagEditViewController: UIViewController {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let titleLabel = UILabel()
    let mainContentView = UIView()
    let labelColor = UIView()
    let textField = XOTextField(.init(top: 12, left: 12, bottom: 12, right: 12))
    let cancelView = XOBorderLabel("取消", color: .systemPink, padding: .init(top: 10, left: 16, bottom: 10, right: 16))
    let updateView = XOBorderLabel("更改", color: .systemBlue, padding: .init(top: 10, left: 16, bottom: 10, right: 16))

    var tagData: TagData = .initEmpty()
    var indexPath: IndexPath?
    weak var delegate: TagEditViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        layout()
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(_ data: TagData, indexPath: IndexPath) {
        self.tagData = data
        self.indexPath = indexPath

        labelColor.backgroundColor = data.getColor
        textField.text = data.label
    }

    private func setup() {
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundViewAction)))
        blurView.isUserInteractionEnabled = true

        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 10.0

        titleLabel.text = "編輯標籤"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        labelColor.layer.cornerRadius = 10.0
        labelColor.layer.borderWidth = 1.0
        labelColor.layer.borderColor = UIColor.systemGray.cgColor
        labelColor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectColorAction)))
        labelColor.isUserInteractionEnabled = true

        textField.placeholder = "輸入標籤名稱"
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .white
        textField.clipsToBounds = true
        textField.delegate = self

        cancelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelAction)))
        cancelView.isUserInteractionEnabled = true

        updateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateAction)))
        updateView.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 3 / 4)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            mainContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        mainContentView.addSubview(labelColor)
        labelColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelColor.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            labelColor.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            labelColor.widthAnchor.constraint(equalToConstant: 20),
            labelColor.heightAnchor.constraint(equalToConstant: 20)
        ])

        mainContentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: labelColor.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 2 / 5)
        ])

        contentView.addSubview(cancelView)
        cancelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            cancelView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -24)
        ])

        contentView.addSubview(updateView)
        updateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            updateView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 24),
            updateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}

// MARK: - Utility
extension TagEditViewController {
    @objc private func tapBackgroundViewAction() {
        if textField.isEditing {
            textField.resignFirstResponder()
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func cancelAction() {
        dismiss(animated: true)
    }

    @objc private func updateAction() {
        tagData.label = textField.text ?? ""
        tagData.color = labelColor.backgroundColor?.toHexString ?? ""
        delegate?.updateTag(data: tagData, indexPath: indexPath)
        dismiss(animated: true)
    }

    @objc private func selectColorAction() {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        present(controller, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension TagEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension TagEditViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        labelColor.backgroundColor = viewController.selectedColor
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        labelColor.backgroundColor = color
    }
}
