// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MainViewController: UIViewController {
    let ledgerLabel = UILabel()
    let recentView = MRecentContentView()
    let quickLogView = MQuickLogView()
    let pieChartView = MPieChartView()

    let manager = MainManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        manager.vc = self
        view.backgroundColor = .white

        ledgerLabel.font = .systemFont(ofSize: 18, weight: .bold)
        ledgerLabel.textColor = .black
        ledgerLabel.numberOfLines = 1

        quickLogView.delegate = self
    }

    private func layout() {
        view.addSubview(ledgerLabel)
        ledgerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ledgerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ledgerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12)
        ])

        view.addSubview(recentView)
        recentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentView.topAnchor.constraint(equalTo: ledgerLabel.bottomAnchor, constant: 12),
            recentView.leadingAnchor.constraint(equalTo: ledgerLabel.leadingAnchor),
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

        view.addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: quickLogView.bottomAnchor, constant: 24),
            pieChartView.leadingAnchor.constraint(equalTo: recentView.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: recentView.trailingAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
