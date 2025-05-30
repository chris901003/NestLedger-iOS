// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonFunction

protocol NewTagCellDelegate: NLNeedPresent {
    func sendNewTag(data: TagData)
}

class NewTagCell: UITableViewCell {
    static let cellId = "NewTagCellId"

    let colorCircle = UIView()
    let tagLabel = UITextField()
    let sendIcon = UIImageView()

    weak var delegate: NewTagCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        colorCircle.layer.cornerRadius = colorCircle.bounds.width / 2
    }

    private func setDefault() {
        colorCircle.backgroundColor = .clear
        tagLabel.text = ""
    }

    private func setup() {
        selectionStyle = .none

        colorCircle.backgroundColor = .clear
        colorCircle.layer.borderColor = UIColor.systemGray5.cgColor
        colorCircle.layer.borderWidth = 1.5
        colorCircle.isUserInteractionEnabled = true
        colorCircle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectColorAction)))

        tagLabel.placeholder = "輸入新的標籤名稱"
        tagLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tagLabel.delegate = self

        sendIcon.image = UIImage(systemName: "paperplane.fill")
        sendIcon.contentMode = .scaleAspectFit
        sendIcon.isUserInteractionEnabled = true
        sendIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendAction)))
    }

    private func layout() {
        contentView.addSubview(colorCircle)
        colorCircle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorCircle.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            colorCircle.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            colorCircle.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            colorCircle.widthAnchor.constraint(equalTo: colorCircle.heightAnchor)
        ])

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: colorCircle.trailingAnchor, constant: 24),
            tagLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            tagLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        contentView.addSubview(sendIcon)
        sendIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendIcon.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 24),
            sendIcon.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            sendIcon.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            sendIcon.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            sendIcon.widthAnchor.constraint(equalTo: sendIcon.heightAnchor)
        ])
    }
}

// MARK: - Utility
extension NewTagCell {
    @objc private func selectColorAction() {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        delegate?.presentVC(controller)
    }

    @objc private func sendAction() {
        tagLabel.resignFirstResponder()
        guard let color = colorCircle.backgroundColor, color != .clear,
              let label = tagLabel.text, !label.isEmpty else {
            let okAction = UIAlertAction(title: "確認", style: .default)
            let controller = UIAlertController(title: "添加失敗", message: "缺少顏色或是標籤名稱", preferredStyle: .alert)
            controller.addAction(okAction)
            delegate?.presentVC(controller)
            return
        }
        delegate?.sendNewTag(data: .init(label: label, color: color.toHexString, ledgerId: "", version: TAG_DATA_VERSION))
        setDefault()
    }
}

// MARK: - UITextFieldDelegate
extension NewTagCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension NewTagCell: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorCircle.backgroundColor = viewController.selectedColor
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        colorCircle.backgroundColor = color
    }
}
