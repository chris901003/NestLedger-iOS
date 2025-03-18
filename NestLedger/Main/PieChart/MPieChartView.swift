// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/18.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class XOAnimatedPieChartView: UIView {
    var data: [(value: CGFloat, color: UIColor)] = [] {
        didSet { createPieChart() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        createPieChart()
    }

    private func createFanPath(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        return path
    }

    private func createPieChart() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        if data.isEmpty { return }

        var startAngle: CGFloat = -CGFloat.pi / 2
        let total = data.reduce(0) { $0 + $1.value }
        var delay: CFTimeInterval = 0

        for segment in data {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = createFanPath(startAngle: startAngle, endAngle: startAngle).cgPath
            shapeLayer.fillColor = segment.color.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 0
            layer.addSublayer(shapeLayer)

            let endAngle = startAngle + (segment.value / total) * 2 * .pi

            let fromPath = createFanPath(startAngle: startAngle, endAngle: startAngle).cgPath
            let endPath = createFanPath(startAngle: startAngle, endAngle: endAngle).cgPath
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = fromPath
            animation.toValue = endPath
            animation.duration = 0.3
            animation.beginTime = CACurrentMediaTime() + delay
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false

            shapeLayer.add(animation, forKey: "fanAnimation")

            startAngle = endAngle
            delay += 0.1
        }
    }
}

class MPCTagCell: UITableViewCell {
    static let cellId = "MPCTagCellId"

    let tagColor = UIView()
    let tagLabel = UILabel()
    let percentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(label: String, color: UIColor, percent: Int) {
        tagColor.backgroundColor = color
        tagLabel.text = label
        percentLabel.text = "\(percent)%"
    }

    private func setup() {
        selectionStyle = .none

        tagColor.layer.cornerRadius = 10.0
        tagColor.clipsToBounds = true

        tagLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tagLabel.numberOfLines = 1
        tagLabel.textColor = .black
        tagLabel.textAlignment = .left

        percentLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        percentLabel.numberOfLines = 1
        percentLabel.textAlignment = .right
        percentLabel.textColor = .black
    }

    private func layout() {
        contentView.addSubview(tagColor)
        tagColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagColor.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            tagColor.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagColor.heightAnchor.constraint(equalToConstant: 20),
            tagColor.widthAnchor.constraint(equalTo: tagColor.heightAnchor)
        ])

        contentView.addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            percentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: tagColor.trailingAnchor, constant: 8),
            tagLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8)
        ])
    }
}

class MPieChartView: UIView {
    let manager = MPieChartManager()

    let dateLabel = UILabel()
    let prevIcon = UIImageView()
    let nextIcon = UIImageView()
    let pieChartView = XOAnimatedPieChartView()
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

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(nextIcon)
        nextIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextIcon.topAnchor.constraint(equalTo: topAnchor),
            nextIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(prevIcon)
        prevIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            prevIcon.topAnchor.constraint(equalTo: topAnchor),
            prevIcon.trailingAnchor.constraint(equalTo: nextIcon.leadingAnchor, constant: -16),
            prevIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -12),
            pieChartView.heightAnchor.constraint(equalTo: pieChartView.widthAnchor)
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
