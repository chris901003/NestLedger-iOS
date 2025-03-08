// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class TagCell: UITableViewCell {
    let colorView = UIView()
    let titleLabel = UILabel()

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
        colorView.layer.cornerRadius = colorView.bounds.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        colorView.backgroundColor = .tintColor
        titleLabel.text = "Unkown Tag"
    }

    func config(color: UIColor, label: String) {
        colorView.backgroundColor = color
        titleLabel.text = label
    }

    private func setup() {
        selectionStyle = .none

        colorView.backgroundColor = .tintColor

        titleLabel.text = "Unkown Tag"
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black
    }

    private func layout() {
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            colorView.widthAnchor.constraint(equalTo: colorView.heightAnchor)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
