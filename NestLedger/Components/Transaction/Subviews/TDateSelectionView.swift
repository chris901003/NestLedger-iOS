// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/3.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol TDateSelectionViewDelegate: AnyObject {
    func changeDate(newDate: Date)
}

class TDateSelectionView: UIView {
    let titleLabel = UILabel()
    let dateLabel = UITextField()
    let datePicker = UIDatePicker()

    weak var delegate: TDateSelectionViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(date: Date) {
        dateLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd_ch, date: date)
        datePicker.date = date
    }

    private func setup() {
        titleLabel.text = "帳目日期:"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1

        dateLabel.placeholder = "請選擇日期"
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.textAlignment = .right
        dateLabel.inputView = datePicker

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        dateLabel.inputAccessoryView = toolbar
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    @objc private func donePressed() {
        dateLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd_ch, date: datePicker.date)
        delegate?.changeDate(newDate: datePicker.date)
        endEditing(true)
    }
}
