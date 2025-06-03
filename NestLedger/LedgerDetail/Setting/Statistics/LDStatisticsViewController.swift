// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/3.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LDStatisticsViewController: UIViewController {
    let titleLabel = UILabel()
    let closeButton = XOPaddedImageView(
        padding: .init(top: 4, left: 4, bottom: 4, right: 4),
        image: UIImage(systemName: "xmark")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        titleLabel.text = "統計"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        closeButton.contentMode = .scaleAspectFit
        closeButton.layer.cornerRadius = 15
        closeButton.layer.borderWidth = 1.5
        closeButton.layer.borderColor = UIColor.systemRed.cgColor
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
    }

    private func layout() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func closeAction() {
        dismiss(animated: true)
    }
}
