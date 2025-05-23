// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI
import xxooooxxCommonFunction

class AccountViewController: UIViewController {
    let titleInfoCellId = "TitleInfoCellId"
    let titleInfoIconCellId = "TitleInfoIconCellId"
    let centerLabelCellId = "CenterLabelCellId"

    let manager = AccountVCManager()

    let avatarView = XOAvatarView(UIImage(named: "avatar")!)
    let userNameView = XOTextField()
    let emailView = XOTextField()
    let tableViewBackground = UIView()
    let settingTableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewBackground.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }

    func config() {
        userNameView.text = manager.userInfo.userName.isEmpty ? "未知" : manager.userInfo.userName
        emailView.text = manager.userInfo.emailAddress.isEmpty ? "未知" : manager.userInfo.emailAddress
        if let avatar = manager.avatar { avatarView.config(avatar) }
    }

    private func setup() {
        view.backgroundColor = .white
        manager.controller = self
        addTapBackgroundDismissKeyboard()

        avatarView.delegate = self
        avatarView.layer.cornerRadius = 120 / 2
        avatarView.clipsToBounds = true
        if let image = manager.avatar {
            avatarView.config(image)
        }

        userNameView.tag = 0
        userNameView.backgroundColor = .white
        userNameView.autocorrectionType = .no
        userNameView.placeholder = "暱稱"
        userNameView.keyboardType = .default
        userNameView.text = manager.userInfo.userName
        userNameView.font = .systemFont(ofSize: 18, weight: .bold)
        userNameView.textColor = .black
        userNameView.delegate = self
        userNameView.layer.borderWidth = 1.5
        userNameView.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        userNameView.layer.cornerRadius = 5

        emailView.tag = 1
        emailView.backgroundColor = .white
        emailView.autocorrectionType = .no
        emailView.keyboardType = .emailAddress
        emailView.placeholder = "電子郵件"
        emailView.text = manager.userInfo.emailAddress
        emailView.font = .systemFont(ofSize: 12, weight: .semibold)
        emailView.textColor = .systemGray
        emailView.delegate = self
        emailView.layer.borderWidth = 1.5
        emailView.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        emailView.layer.cornerRadius = 5

        tableViewBackground.backgroundColor = .systemGray6

        settingTableView.backgroundColor = .black.withAlphaComponent(0)
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.clipsToBounds = true
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

        view.addSubview(tableViewBackground)
        tableViewBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewBackground.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            tableViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableViewBackground.addSubview(settingTableView)
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: tableViewBackground.topAnchor, constant: -12),
            settingTableView.leadingAnchor.constraint(equalTo: tableViewBackground.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: tableViewBackground.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: tableViewBackground.bottomAnchor)
        ])
    }

    private func registerCell() {
        settingTableView.register(XOLeadingTrailingLabelWithIconCell.self, forCellReuseIdentifier: titleInfoIconCellId)
        settingTableView.register(XOLeadingTrailingLabelCell.self, forCellReuseIdentifier: titleInfoCellId)
        settingTableView.register(XOCenterLabelCell.self, forCellReuseIdentifier: centerLabelCellId)
    }
}

// MARK: - XOAvatarViewDelegate
extension AccountViewController: XOAvatarViewDelegate {
    func presentPhotoSelector(vc: UIViewController) {
        present(vc, animated: true)
    }

    func newAvatar(image: UIImage) {
        manager.avatar = image
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
        switch textField.tag {
            case 0:
                guard let newUserName = textField.text,
                      !newUserName.isEmpty else {
                    userNameView.text = manager.userInfo.userName
                    return true
                }
                manager.userInfo.userName = newUserName
            case 1:
                guard let newEmail = textField.text,
                      newEmail.isValidEmail() else {
                    emailView.text = manager.userInfo.emailAddress
                    return true
                }
                manager.userInfo.emailAddress = newEmail
            default:
                break
        }
        return true
    }
}
