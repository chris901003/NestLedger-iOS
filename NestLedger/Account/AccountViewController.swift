// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class AccountViewController: UIViewController {
    let avatarView = XOAvatarView(UIImage(named: "avatar")!)
    let userNameView = XOTextField()
    let emailView = XOTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        avatarView.delegate = self
        avatarView.layer.cornerRadius = 120 / 2
        avatarView.clipsToBounds = true

        userNameView.backgroundColor = .white
        userNameView.placeholder = "暱稱"
        userNameView.text = "XXOOOOXX"
        userNameView.font = .systemFont(ofSize: 18, weight: .bold)
        userNameView.textColor = .black
        userNameView.delegate = self
        userNameView.layer.borderWidth = 1.5
        userNameView.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        userNameView.layer.cornerRadius = 5

        emailView.backgroundColor = .white
        emailView.placeholder = "電子郵件"
        emailView.text = "service@xxooooxx.org"
        emailView.font = .systemFont(ofSize: 12, weight: .semibold)
        emailView.textColor = .systemGray
        emailView.delegate = self
        emailView.layer.borderWidth = 1.5
        emailView.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        emailView.layer.cornerRadius = 5
    }

    private func layout() {
        view.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48),
            avatarView.heightAnchor.constraint(equalToConstant: 120),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor)
        ])

        view.addSubview(userNameView)
        userNameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            userNameView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48),
            userNameView.bottomAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: -4)
        ])

        view.addSubview(emailView)
        emailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailView.leadingAnchor.constraint(equalTo: userNameView.leadingAnchor),
            emailView.trailingAnchor.constraint(equalTo: userNameView.trailingAnchor),
            emailView.topAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: 4)
        ])
    }
}

// MARK: - XOAvatarViewDelegate
extension AccountViewController: XOAvatarViewDelegate {
    func presentPhotoSelector(vc: UIViewController) {
        present(vc, animated: true)
    }

    func newAvatar(image: UIImage) {
        print("✅ New avatar")
    }
}

// MARK: - UITextFieldDelegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25) {
            textField.layer.borderColor = UIColor.black.cgColor
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25) {
            textField.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        }
        return true
    }
}
