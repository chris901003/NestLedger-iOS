// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MRecentContentView: UIView {
    let cellId = "CellID"

    let manager = MRecntManager()

    let infoLabel = UILabel()
    let tableView = UITableView()

    init() {
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20.0
        clipsToBounds = true

        infoLabel.text = "近期紀錄"
        infoLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 1

        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    private func registerCell() {
        tableView.register(MRCCell.self, forCellReuseIdentifier: cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MRecentContentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MRCCell else {
            return UITableViewCell()
        }
        return cell
    }
}
