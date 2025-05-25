// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MainViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let refreshControl = UIRefreshControl()

    let ledgerLabel = UILabel()
    let recentView = MRecentContentView()
    let quickLogView = MQuickLogView()
    let pieChartView = MPieChartView()

    let manager = MainManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setup() {
        manager.vc = self
        view.backgroundColor = .white

        scrollView.keyboardDismissMode = .onDrag

        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMainView), for: .valueChanged)

        ledgerLabel.font = .systemFont(ofSize: 18, weight: .bold)
        ledgerLabel.textColor = .black
        ledgerLabel.numberOfLines = 1

        quickLogView.delegate = self
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)])

        contentView.addSubview(ledgerLabel)
        ledgerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: ledgerLabel.topAnchor),
            ledgerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            ledgerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            ledgerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])

        contentView.addSubview(recentView)
        recentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentView.topAnchor.constraint(equalTo: ledgerLabel.bottomAnchor, constant: 12),
            recentView.leadingAnchor.constraint(equalTo: ledgerLabel.leadingAnchor),
            recentView.trailingAnchor.constraint(equalTo: ledgerLabel.trailingAnchor),
            recentView.heightAnchor.constraint(equalToConstant: 150)
        ])

        contentView.addSubview(quickLogView)
        quickLogView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quickLogView.topAnchor.constraint(equalTo: recentView.bottomAnchor, constant: 24),
            quickLogView.leadingAnchor.constraint(equalTo: recentView.leadingAnchor),
            quickLogView.trailingAnchor.constraint(equalTo: recentView.trailingAnchor)
        ])

        contentView.addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: quickLogView.bottomAnchor, constant: 24),
            pieChartView.leadingAnchor.constraint(equalTo: recentView.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: recentView.trailingAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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

// MARK: - Refresh
extension MainViewController {
    @objc private func refreshMainView() {
        manager.refreshData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Keyboard
extension MainViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = keyboardHeight
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            self.scrollView.scrollRectToVisible(self.quickLogView.totalLabel.frame, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
