// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/11.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CopyTagToOtherLedgerViewController: UIViewController {
    let backButtonView = LDSCTBackButtonView()
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        backButtonView.isUserInteractionEnabled = true
        backButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackAction)))

        titleLabel.text = "複製標籤到其他帳本"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center
    }

    private func layout() {
        view.addSubview(backButtonView)
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            backButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func tapBackAction() {
        dismiss(animated: true)
    }
}
