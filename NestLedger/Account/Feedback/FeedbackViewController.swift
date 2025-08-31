// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class FeedbackViewController: UIViewController {
    let topBarView = UIView()
    let feedbackInputView: FeedbackInputView
    let feedbackSuccessView = FeedbackSuccessView()

    let manager = FeedbackManager()
    var bottomViewHeightConstraint: NSLayoutConstraint!

    init() {
        self.feedbackInputView = FeedbackInputView(manager: manager)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white
        presentationController?.delegate = self

        feedbackInputView.delegate = self

        feedbackSuccessView.delegate = self
        feedbackSuccessView.alpha = 0
    }

    private func layout() {
        view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBarView.widthAnchor.constraint(equalToConstant: 30),
            topBarView.heightAnchor.constraint(equalToConstant: 4)
        ])

        view.addSubview(feedbackInputView)
        feedbackInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackInputView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            feedbackInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedbackInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedbackInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(feedbackSuccessView)
        feedbackSuccessView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackSuccessView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            feedbackSuccessView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedbackSuccessView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedbackSuccessView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension FeedbackViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return manager.allowDismiss
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "要關閉嗎？", message: "資料將會遺失", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "確定關閉", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.manager.allowDismiss = true
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - FeedbackInputViewDelegate
extension FeedbackViewController: FeedbackInputViewDelegate {
    func sendFeedbackSuccess() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            feedbackInputView.alpha = 0
            feedbackSuccessView.alpha = 1
        }
    }
}

// MARK: - FeedbackSuccessViewDelegate
extension FeedbackViewController: FeedbackSuccessViewDelegate {
    func dismissView() {
        dismiss(animated: true)
    }
}
