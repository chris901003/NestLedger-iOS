// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol MQLSendViewDelegate: AnyObject {
    func sendAction(completion: @escaping () -> Void)
}

class MQLSendView: UIView {
    let iconView = UIImageView()
    let label = UILabel()
    let spinner = UIActivityIndicatorView(style: .medium)

    weak var delegate: MQLSendViewDelegate?

    var iconViewLeadingConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))

        iconView.image = UIImage(systemName: "play.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        iconView.isUserInteractionEnabled = true

        label.text = "添加紀錄"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isUserInteractionEnabled = true

        spinner.alpha = 0
    }

    private func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])
        iconViewLeadingConstraint = iconView.leadingAnchor.constraint(equalTo: leadingAnchor)
        iconViewLeadingConstraint?.isActive = true

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])

        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func tapAction() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0) { [weak self] in
                guard let self else { return }
                label.alpha = 0
                iconViewLeadingConstraint?.constant = label.bounds.width
                layoutIfNeeded()
            }
            UIView.animate(withDuration: 1.0) { [weak self] in
                guard let self else { return }
                iconView.alpha = 0
            } completion: { [weak self] _ in
                guard let self else { return }
                spinner.alpha = 1
                spinner.startAnimating()
                delegate?.sendAction(completion: finishedSend)
            }
        }
    }

    private func finishedSend() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                spinner.alpha = 0
                spinner.stopAnimating()
            }
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                label.alpha = 1
                iconView.alpha = 1
                iconViewLeadingConstraint?.constant = 0
                layoutIfNeeded()
            }
        }
    }
}
