// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol FeedbackSuccessViewDelegate: AnyObject {
    func dismissView()
}

class FeedbackSuccessView: UIView {
    let imageView = UIImageView()
    let infoLabel = UILabel()
    let closeButton = XOBorderLabel("關閉", color: .systemBlue, padding: .init(top: 8, left: 12, bottom: 8, right: 12))

    var delegate: FeedbackSuccessViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white

        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark.square")

        infoLabel.text = "您的回饋已送出，感謝一起讓共同記帳變得更好！"
        infoLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0

        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCloseButton)))
        closeButton.isUserInteractionEnabled = true
    }

    private func layout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])

        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24),
            closeButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func tapCloseButton() {
        delegate?.dismissView()
    }
}
