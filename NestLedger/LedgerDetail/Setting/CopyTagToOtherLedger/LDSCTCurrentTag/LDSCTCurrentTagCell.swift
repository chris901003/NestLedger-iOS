// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol LDSCTCurrentTagCellDelegate: AnyObject {
    func tag(isSelected: Bool, tagId: String)
}

class LDSCTCurrentTagCell: UITableViewCell {
    static let cellId = "LDSCTCurrentTagCellId"

    let checkboxView = XOCheckBox()
    let circleView = UIView()
    let tagLabel = UILabel()

    var tagData: TagData?
    weak var delegate: LDSCTCurrentTagCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        defaultConfig()
    }

    func config(tagData: TagData, isSelected: Bool) {
        self.tagData = tagData
        checkboxView.config(isSelected: isSelected)
        circleView.backgroundColor = tagData.getColor
        tagLabel.text = tagData.label
    }

    private func defaultConfig() {
        circleView.backgroundColor = .systemGray5
        tagLabel.text = "標籤名稱"
    }

    private func setup() {
        selectionStyle = .none
        defaultConfig()

        checkboxView.delegate = self

        circleView.layer.cornerRadius = 10

        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLabel.textAlignment = .left
    }

    private func layout() {
        contentView.addSubview(checkboxView)
        checkboxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkboxView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            checkboxView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        ])

        contentView.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: checkboxView.trailingAnchor, constant: 12),
            circleView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 20),
            circleView.heightAnchor.constraint(equalToConstant: 20)
        ])

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
    }
}

// MARK: - XOCheckBoxDelegate
extension LDSCTCurrentTagCell: XOCheckBoxDelegate {
    func xoCheckBox(_ checkBox: XOCheckBox, didChangeIsSelected isSelected: Bool) {
        delegate?.tag(isSelected: isSelected, tagId: tagData?._id ?? "")
    }
}
