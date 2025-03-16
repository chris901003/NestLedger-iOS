// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MainViewController: UIViewController {
    let todayLabel = UILabel()
    let recentView = MRecentContentView()
    let quickLogView = MQuickLogView()
    let calendarView = MCalendarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        todayLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd_ch, date: Date.now)
        todayLabel.font = .systemFont(ofSize: 18, weight: .bold)
        todayLabel.textColor = .black
        todayLabel.numberOfLines = 1

        quickLogView.delegate = self
    }

    private func layout() {
        view.addSubview(todayLabel)
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12)
        ])

        view.addSubview(recentView)
        recentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 12),
            recentView.leadingAnchor.constraint(equalTo: todayLabel.leadingAnchor),
            recentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            recentView.heightAnchor.constraint(equalToConstant: 150)
        ])

        view.addSubview(quickLogView)
        quickLogView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quickLogView.topAnchor.constraint(equalTo: recentView.bottomAnchor, constant: 24),
            quickLogView.leadingAnchor.constraint(equalTo: recentView.leadingAnchor),
            quickLogView.trailingAnchor.constraint(equalTo: recentView.trailingAnchor)
        ])

        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: quickLogView.bottomAnchor, constant: 24),
            calendarView.leadingAnchor.constraint(equalTo: recentView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: recentView.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - NLNeedPresent
extension MainViewController: NLNeedPresent {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
}
