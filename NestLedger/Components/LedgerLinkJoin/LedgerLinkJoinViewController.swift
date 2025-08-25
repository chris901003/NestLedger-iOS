// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LedgerLinkJoinViewController: UIViewController {
    let token: String
    let ledgerId: String
    let manager = LedgerLinkJoinManager()

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()

    init(token: String, ledgerId: String) {
        self.token = token
        self.ledgerId = ledgerId
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0
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
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 3 / 4),
            contentView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
