// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MCalendarView: UIView {
    let yearMonthLabel = UILabel()
    let backIcon = UIImageView()
    let forwardIcon = UIImageView()

    var selectedDay = Date.now

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
//        backgroundColor = .systemGray6
        yearMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: Date.now)
        yearMonthLabel.textColor = .black
        yearMonthLabel.font = .systemFont(ofSize: 16, weight: .bold)
        yearMonthLabel.numberOfLines = 1

        backIcon.image = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        backIcon.contentMode = .scaleAspectFit
        backIcon.isUserInteractionEnabled = true
        backIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousMonthAction)))

        forwardIcon.image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        forwardIcon.contentMode = .scaleAspectFit
        forwardIcon.isUserInteractionEnabled = true
        forwardIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextMonthAction)))
    }

    private func layout() {
        addSubview(yearMonthLabel)
        yearMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearMonthLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            yearMonthLabel.topAnchor.constraint(equalTo: topAnchor)
        ])

        addSubview(forwardIcon)
        forwardIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forwardIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            forwardIcon.topAnchor.constraint(equalTo: yearMonthLabel.topAnchor),
            forwardIcon.bottomAnchor.constraint(equalTo: yearMonthLabel.bottomAnchor),
            forwardIcon.widthAnchor.constraint(equalTo: forwardIcon.heightAnchor)
        ])

        addSubview(backIcon)
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backIcon.trailingAnchor.constraint(equalTo: forwardIcon.leadingAnchor, constant: -8),
            backIcon.heightAnchor.constraint(equalTo: forwardIcon.heightAnchor),
            backIcon.widthAnchor.constraint(equalTo: backIcon.heightAnchor)
        ])
    }
}

// MARK: - Utility
extension MCalendarView {
    @objc private func previousMonthAction() {
        print("✅ Previous Month")
    }

    @objc private func nextMonthAction() {
        print("✅ Next Month")
    }
}
