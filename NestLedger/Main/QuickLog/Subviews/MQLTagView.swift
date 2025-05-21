// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol NLNeedPresent: AnyObject {
    func presentVC(_ vc: UIViewController)
}

protocol MQLTagViewDelegate: NLNeedPresent {
    func selectedTag(tag: TagData)
}

class MQLTagView: UIView {
    let colorView = UIView()
    let tagLabel = UILabel()

    weak var delegate: MQLTagViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        colorView.backgroundColor = .clear
        colorView.layer.borderColor = UIColor.secondaryLabel.cgColor
        tagLabel.text = "點擊選擇類別"
    }

    private func setup() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))

        colorView.layer.cornerRadius = 15 / 2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.secondaryLabel.cgColor

        tagLabel.text = "點擊選擇類別"
        tagLabel.textColor = .secondaryLabel
        tagLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tagLabel.numberOfLines = 1
        tagLabel.textAlignment = .center
    }

    private func layout() {
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            colorView.heightAnchor.constraint(equalToConstant: 15),
            colorView.widthAnchor.constraint(equalToConstant: 15)
        ])

        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tagLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            tagLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - Utility
extension MQLTagView {
    @objc private func tapAction() {
        let tagViewController = TagViewController(type: .selectTag, ledgerId: newSharedUserInfo.ledgerIds.first ?? "")
        tagViewController.delegate = self
        let _70DetentId = UISheetPresentationController.Detent.Identifier("70")
        let _70Detent = UISheetPresentationController.Detent.custom(identifier: _70DetentId) { context in
            return UIScreen.main.bounds.height * 0.7
        }
        if let sheet = tagViewController.sheetPresentationController {
            sheet.detents = [_70Detent]
        }
        delegate?.presentVC(tagViewController)
    }
}

// MARK: - TagViewControllerDelegate
extension MQLTagView: TagViewControllerDelegate {
    func selectedTag(vc: UIViewController, data: TagData) {
        colorView.backgroundColor = data.getColor
        colorView.layer.borderColor = data.getColor.cgColor
        tagLabel.text = data.label
        delegate?.selectedTag(tag: data)
        vc.dismiss(animated: true)
    }
}
