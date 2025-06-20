// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/18.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

extension MPieChartView {
    enum PieChartType {
        case income, expenditure
    }
}

class MPieChartView: UIView {
    let manager: MPieChartManager
    let type: PieChartType

    let dateLabel = UILabel()
    let prevIcon = UIImageView()
    let nextIcon = UIImageView()
    let pieChartView = XOAnimatedPieChartView()
    let typeLabel: XOBorderLabel
    let tableView = UITableView()

    init(type: PieChartType) {
        self.type = type
        self.manager = MPieChartManager(type: type)
        typeLabel = XOBorderLabel(
            type == .income ? "收入" : "支出",
            color: type == .income ? UIColor(hexCode: "#B1DD8B") : UIColor(hexCode: "#FF8484"),
            padding: .init(top: 8, left: 12, bottom: 8, right: 12)
        )
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        manager.vc = self

        dateLabel.text = "\(manager.year)年 \(manager.month)月"
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.numberOfLines = 1

        prevIcon.image = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        prevIcon.contentMode = .scaleAspectFit
        prevIcon.isUserInteractionEnabled = true
        prevIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prevAction)))

        nextIcon.image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        nextIcon.contentMode = .scaleAspectFit
        nextIcon.isUserInteractionEnabled = true
        nextIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextAction)))

        typeLabel.backgroundColor = .white
        typeLabel.configLabel(font: .systemFont(ofSize: 16, weight: .bold))
        typeLabel.configBorder(radius: 16, width: 0)

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        addSubview(nextIcon)
        nextIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextIcon.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            nextIcon.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            nextIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(prevIcon)
        prevIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            prevIcon.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            prevIcon.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            prevIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 24),
            pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -12),
            pieChartView.heightAnchor.constraint(equalTo: pieChartView.widthAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeLabel.centerXAnchor.constraint(equalTo: pieChartView.centerXAnchor),
            typeLabel.centerYAnchor.constraint(equalTo: pieChartView.centerYAnchor)
        ])

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: pieChartView.topAnchor, constant: -12),
            tableView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 12)
        ])
    }

    private func registerCell() {
        tableView.register(MPCTagCell.self, forCellReuseIdentifier: MPCTagCell.cellId)
    }

    @objc private func prevAction() {
        manager.year = manager.month == 1 ? manager.year - 1 : manager.year
        manager.month = manager.month == 1 ? 12 : manager.month - 1
        Task { try? await manager.loadLedgerInfo() }
        dateLabel.text = "\(manager.year)年 \(manager.month)月"
    }

    @objc private func nextAction() {
        manager.year = manager.month == 12 ? manager.year + 1 : manager.year
        manager.month = manager.month == 12 ? 1 : manager.month + 1
        Task { try? await manager.loadLedgerInfo() }
        dateLabel.text = "\(manager.year)年 \(manager.month)月"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPieChartView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.pieChartData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MPCTagCell.cellId, for: indexPath) as? MPCTagCell else {
            return UITableViewCell()
        }
        let data = manager.pieChartData[indexPath.row]
        cell.config(label: data.tagLabel, color: data.tagColor, percent: data.percent)
        return cell
    }
}
