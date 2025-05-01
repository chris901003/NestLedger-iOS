// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/30.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class ReceiveLedgerInviteViewController: UIViewController {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let contentView = UIView()
    let titleLabel = UILabel()
    let closeLabel = UILabel()
    let tableView = UITableView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0

        titleLabel.text = "帳本邀請列表"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center

        closeLabel.text = "關閉"
        closeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        closeLabel.numberOfLines = 1
        closeLabel.textColor = .systemBlue
        closeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCloseAction)))
        closeLabel.isUserInteractionEnabled = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 2 / 3)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        contentView.addSubview(closeLabel)
        closeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            closeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])

        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func registerCell() {
        tableView.register(RLICell.self, forCellReuseIdentifier: RLICell.cellId)
    }

    @objc private func tapCloseAction() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ReceiveLedgerInviteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RLICell.cellId, for: indexPath) as? RLICell else {
            return UITableViewCell()
        }
        return cell
    }
}
