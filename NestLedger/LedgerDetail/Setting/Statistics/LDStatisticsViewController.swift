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
    let titleUnderLineView = UIView()
    let intervalLabel = UILabel()
    let startLabel = XOBorderLabel("2025-01-01", color: .systemGray, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    let startDatePicker = UIDatePicker()
    let toImageView = UIImageView()
    let endLabel = XOBorderLabel("2025-01-31", color: .systemGray, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    let endDatePicker = UIDatePicker()
    let searchView = LDSSearchView()

    let selectView = UIView()
    let selectedBackgroundView = UIView()
    let incomeSelectLabel = UILabel()
    let expenseSelectLabel = UILabel()
    let totalSelectLabel = UILabel()

    let closeButton = XOPaddedImageView(
        padding: .init(top: 4, left: 4, bottom: 4, right: 4),
        image: UIImage(systemName: "xmark")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    )

    var selectedBackgroundViewLeadingConstraint: NSLayoutConstraint?

    let manager = LDStatisticsManager()
    var isLayout = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !isLayout else { return }
        isLayout = true
        NSLayoutConstraint.activate([
            selectedBackgroundView.widthAnchor.constraint(equalToConstant: selectView.frame.width / 3),
            selectedBackgroundView.topAnchor.constraint(equalTo: selectView.topAnchor),
            selectedBackgroundView.bottomAnchor.constraint(equalTo: selectView.bottomAnchor)
        ])
        selectedBackgroundViewLeadingConstraint = selectedBackgroundView.leadingAnchor.constraint(equalTo: selectView.leadingAnchor, constant: 0)
        selectedBackgroundViewLeadingConstraint?.isActive = true

        NSLayoutConstraint.activate([
            expenseSelectLabel.centerXAnchor.constraint(equalTo: selectView.centerXAnchor),
            expenseSelectLabel.widthAnchor.constraint(equalToConstant: selectView.frame.width / 3),
            expenseSelectLabel.topAnchor.constraint(equalTo: selectView.topAnchor, constant: 16),
            expenseSelectLabel.bottomAnchor.constraint(equalTo: selectView.bottomAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            incomeSelectLabel.leadingAnchor.constraint(equalTo: selectView.leadingAnchor),
            incomeSelectLabel.trailingAnchor.constraint(equalTo: expenseSelectLabel.leadingAnchor),
            incomeSelectLabel.centerYAnchor.constraint(equalTo: selectView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            totalSelectLabel.leadingAnchor.constraint(equalTo: expenseSelectLabel.trailingAnchor),
            totalSelectLabel.trailingAnchor.constraint(equalTo: selectView.trailingAnchor),
            totalSelectLabel.centerYAnchor.constraint(equalTo: selectView.centerYAnchor)
        ])
    }

    private func setup() {
        setDefaultStartDate()

        view.backgroundColor = .white

        titleLabel.text = "統計"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .left

        titleUnderLineView.backgroundColor = .systemGray
        titleUnderLineView.layer.cornerRadius = 2.5

        closeButton.contentMode = .scaleAspectFit
        closeButton.layer.cornerRadius = 15
        closeButton.layer.borderWidth = 1.5
        closeButton.layer.borderColor = UIColor.systemRed.cgColor
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))

        intervalLabel.text = "區間"
        intervalLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        intervalLabel.textAlignment = .left

        startLabel.configBorder(radius: 8)
        startDatePicker.preferredDatePickerStyle = .compact
        startDatePicker.datePickerMode = .date
        startDatePicker.alpha = 0.02
        startDatePicker.addTarget(self, action: #selector(startDateChange), for: .valueChanged)

        toImageView.image = UIImage(systemName: "arrowshape.right.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        toImageView.contentMode = .scaleAspectFit

        endLabel.configBorder(radius: 8)
        endDatePicker.preferredDatePickerStyle = .compact
        endDatePicker.datePickerMode = .date
        endDatePicker.alpha = 0.02
        endDatePicker.addTarget(self, action: #selector(endDateChange), for: .valueChanged)

        searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchAction)))
        searchView.isUserInteractionEnabled = true

        selectView.layer.cornerRadius = 20.0
        selectView.layer.borderWidth = 4.5
        selectView.layer.borderColor = UIColor(hexCode: "#BBFBFF").cgColor
        selectView.clipsToBounds = true

        selectedBackgroundView.backgroundColor = UIColor(hexCode: "#8DD8FF")

        incomeSelectLabel.text = "區間收入"
        incomeSelectLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        incomeSelectLabel.textAlignment = .center
        incomeSelectLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapIncomeAction)))
        incomeSelectLabel.isUserInteractionEnabled = true

        expenseSelectLabel.text = "區間支出"
        expenseSelectLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        expenseSelectLabel.textAlignment = .center
        expenseSelectLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapExpenseAction)))
        expenseSelectLabel.isUserInteractionEnabled = true

        totalSelectLabel.text = "區間總計"
        totalSelectLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        totalSelectLabel.textAlignment = .center
        totalSelectLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTotalAction)))
        totalSelectLabel.isUserInteractionEnabled = true
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
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])

        view.addSubview(titleUnderLineView)
        titleUnderLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleUnderLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            titleUnderLineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleUnderLineView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleUnderLineView.heightAnchor.constraint(equalToConstant: 2)
        ])

        view.addSubview(intervalLabel)
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            intervalLabel.topAnchor.constraint(equalTo: titleUnderLineView.bottomAnchor, constant: 48),
            intervalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        ])

        view.addSubview(startLabel)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startLabel.leadingAnchor.constraint(equalTo: intervalLabel.trailingAnchor, constant: 24),
            startLabel.centerYAnchor.constraint(equalTo: intervalLabel.centerYAnchor)
        ])

        view.addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDatePicker.centerXAnchor.constraint(equalTo: startLabel.centerXAnchor),
            startDatePicker.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor)
        ])

        view.addSubview(toImageView)
        toImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toImageView.leadingAnchor.constraint(equalTo: startLabel.trailingAnchor, constant: 32),
            toImageView.centerYAnchor.constraint(equalTo: intervalLabel.centerYAnchor)
        ])

        view.addSubview(endLabel)
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            endLabel.centerYAnchor.constraint(equalTo: intervalLabel.centerYAnchor)
        ])

        view.addSubview(endDatePicker)
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDatePicker.centerXAnchor.constraint(equalTo: endLabel.centerXAnchor),
            endDatePicker.centerYAnchor.constraint(equalTo: endLabel.centerYAnchor)
        ])

        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 24),
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(selectView)
        selectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 24),
            selectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            selectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])

        selectView.addSubview(selectedBackgroundView)
        selectedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(incomeSelectLabel)
        incomeSelectLabel.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(expenseSelectLabel)
        expenseSelectLabel.translatesAutoresizingMaskIntoConstraints = false
        selectView.addSubview(totalSelectLabel)
        totalSelectLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc private func closeAction() {
        dismiss(animated: true)
    }

    private func setDefaultStartDate() {
        var calendar = Calendar.current
        if let timeZone = TimeZone(secondsFromGMT: newSharedUserInfo.timeZone * 60 * 60) {
            calendar.timeZone = timeZone
        }
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: Date.now)
        components.month = Calendar.current.component(.month, from: Date.now)
        components.day = 1
        guard let startDate = calendar.date(from: components) else { return }
        startLabel.configLabel(text: DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd, date: startDate))
        startDatePicker.date = startDate

        components.day = Calendar.current.range(of: .day, in: .month, for: startDate)?.count
        components.hour = 23
        components.minute = 59
        components.second = 59
        guard let endDate = calendar.date(from: components) else { return }
        endLabel.configLabel(text: DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd, date: endDate))
        endDatePicker.date = endDate

        let minStartDateTime = endDate.addingTimeInterval(-60 * 60 * 24 * 30 * 3)
        startDatePicker.maximumDate = endDate
        startDatePicker.minimumDate = minStartDateTime

        let maxEndDateTime = startDate.addingTimeInterval(60 * 60 * 24 * 30 * 3)
        endDatePicker.maximumDate = maxEndDateTime
        endDatePicker.minimumDate = startDate
    }

    @objc private func startDateChange() {
        startLabel.configLabel(text: DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd, date: startDatePicker.date))
        endDatePicker.minimumDate = startDatePicker.date
        endDatePicker.maximumDate = startDatePicker.date.addingTimeInterval(60 * 60 * 24 * 30 * 3)
    }

    @objc private func endDateChange() {
        endLabel.configLabel(text: DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd, date: endDatePicker.date))
        startDatePicker.maximumDate = endDatePicker.date
        startDatePicker.minimumDate = endDatePicker.date.addingTimeInterval(-60 * 60 * 24 * 30 * 3)
    }
}

// MARK: - Tap Search
extension LDStatisticsViewController {
    @objc private func searchAction() {
        UIView.animate(withDuration: 0.1) {
            self.searchView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.searchView.transform = .identity
            }
        }

        manager.searchAction()
    }
}

extension LDStatisticsViewController {
    @objc private func tapIncomeAction() {
        UIView.animate(withDuration: 0.25) {
            self.selectedBackgroundViewLeadingConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc private func tapExpenseAction() {
        UIView.animate(withDuration: 0.25) {
            self.selectedBackgroundViewLeadingConstraint?.constant = self.selectView.frame.width / 3
            self.view.layoutIfNeeded()
        }
    }

    @objc private func tapTotalAction() {
        UIView.animate(withDuration: 0.25) {
            self.selectedBackgroundViewLeadingConstraint?.constant = 2 * self.selectView.frame.width / 3
            self.view.layoutIfNeeded()
        }
    }
}
