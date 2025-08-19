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

    let pieChartScrollView = UIScrollView()
    let pieChartContentView = UIView()
    let pieChartView = MPieChartView(type: .income)
    let pieChartView2 = MPieChartView(type: .expenditure)

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
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard)))

        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMainView), for: .valueChanged)

        ledgerLabel.font = .systemFont(ofSize: 18, weight: .bold)
        ledgerLabel.textColor = .black
        ledgerLabel.numberOfLines = 1

        quickLogView.delegate = self

        pieChartScrollView.isPagingEnabled = true
        pieChartScrollView.showsHorizontalScrollIndicator = false
        pieChartScrollView.showsVerticalScrollIndicator = false
        pieChartScrollView.bounces = false
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

        contentView.addSubview(pieChartScrollView)
        pieChartScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartScrollView.topAnchor.constraint(equalTo: quickLogView.bottomAnchor, constant: 24),
            pieChartScrollView.leadingAnchor.constraint(equalTo: recentView.leadingAnchor),
            pieChartScrollView.trailingAnchor.constraint(equalTo: recentView.trailingAnchor),
            pieChartScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        pieChartScrollView.addSubview(pieChartContentView)
        pieChartContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartContentView.topAnchor.constraint(equalTo: pieChartScrollView.contentLayoutGuide.topAnchor),
            pieChartContentView.leadingAnchor.constraint(equalTo: pieChartScrollView.contentLayoutGuide.leadingAnchor),
            pieChartContentView.trailingAnchor.constraint(equalTo: pieChartScrollView.contentLayoutGuide.trailingAnchor),
            pieChartContentView.bottomAnchor.constraint(equalTo: pieChartScrollView.contentLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            pieChartScrollView.heightAnchor.constraint(equalTo: pieChartContentView.heightAnchor)
        ])

        pieChartContentView.addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: pieChartContentView.topAnchor),
            pieChartView.leadingAnchor.constraint(equalTo: pieChartContentView.leadingAnchor),
            pieChartView.widthAnchor.constraint(equalTo: recentView.widthAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: pieChartContentView.bottomAnchor)
        ])

        pieChartContentView.addSubview(pieChartView2)
        pieChartView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pieChartView2.topAnchor.constraint(equalTo: pieChartView.topAnchor),
            pieChartView2.leadingAnchor.constraint(equalTo: pieChartView.trailingAnchor),
            pieChartView2.trailingAnchor.constraint(equalTo: pieChartContentView.trailingAnchor),
            pieChartView2.widthAnchor.constraint(equalTo: recentView.widthAnchor),
            pieChartView2.bottomAnchor.constraint(equalTo: pieChartView.bottomAnchor)
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

extension MainViewController {
    @objc private func dissmissKeyboard() {
        view.endEditing(true)
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
