// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/11.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LSTDateSelectViewDelegate: AnyObject {
    func dateValueChanged(date: Date)
}

class LSTDateSelectView: UIView {
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let datePicker = UIDatePicker()

    weak var delegate: LSTDateSelectViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel.text = "帳目日期:"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        dateLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd_ch, date: datePicker.date)
        dateLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        datePicker.datePickerMode = .date
        datePicker.alpha = 0.02
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Utility
extension LSTDateSelectView {
    @objc private func datePickerValueChanged() {
        dateLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd_ch, date: datePicker.date)
        delegate?.dateValueChanged(date: datePicker.date)
    }
}
