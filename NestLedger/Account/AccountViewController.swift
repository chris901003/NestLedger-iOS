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
    let emailNotCheckIcon = UIImageView()
    let emailNotCheckLabel = UILabel()
    let tableViewBackground = UIView()
    let settingTableView = UITableView(frame: .zero, style: .insetGrouped)
    let refreshControl = UIRefreshControl()

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
        if let emailVerificationData = manager.emailVerificationData {
            emailNotCheckIcon.alpha = emailVerificationData.emailAddress != emailView.text ? 1 : 0
            emailNotCheckLabel.alpha = emailVerificationData.emailAddress != emailView.text ? 1 : 0
            emailView.text = emailVerificationData.emailAddress
        } else {
            emailNotCheckIcon.alpha = 0
            emailNotCheckLabel.alpha = 0
        }
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
        emailView.text = manager.emailVerificationData?.emailAddress ?? manager.userInfo.emailAddress
        emailView.font = .systemFont(ofSize: 12, weight: .semibold)
        emailView.textColor = .systemGray
        emailView.delegate = self
        emailView.layer.borderWidth = 1.5
        emailView.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        emailView.layer.cornerRadius = 5

        emailNotCheckIcon.image = UIImage(
            systemName: "exclamationmark.triangle.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        if let emailVerificationData = manager.emailVerificationData {
            emailNotCheckIcon.alpha = emailVerificationData.emailAddress == manager.userInfo.emailAddress ? 0 : 1
        } else {
            emailNotCheckIcon.alpha = 0
        }

        emailNotCheckLabel.text = "此電子郵件尚未驗證"
        emailNotCheckLabel.font = .systemFont(ofSize: 10, weight: .bold)
        emailNotCheckLabel.textColor = .secondaryLabel
        emailNotCheckLabel.numberOfLines = 1
        if let emailVerificationData = manager.emailVerificationData {
            emailNotCheckLabel.alpha = emailVerificationData.emailAddress == manager.userInfo.emailAddress ? 0 : 1
        } else {
            emailNotCheckLabel.alpha = 0
        }

        tableViewBackground.backgroundColor = .systemGray6

        settingTableView.backgroundColor = .black.withAlphaComponent(0)
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.clipsToBounds = true
        settingTableView.keyboardDismissMode = .onDrag
        settingTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
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

        view.addSubview(emailNotCheckIcon)
        emailNotCheckIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailNotCheckIcon.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 4),
            emailNotCheckIcon.leadingAnchor.constraint(equalTo: emailView.leadingAnchor),
            emailNotCheckIcon.heightAnchor.constraint(equalToConstant: 12),
            emailNotCheckIcon.widthAnchor.constraint(equalToConstant: 12)
        ])

        view.addSubview(emailNotCheckLabel)
        emailNotCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailNotCheckLabel.leadingAnchor.constraint(equalTo: emailNotCheckIcon.trailingAnchor, constant: 4),
            emailNotCheckLabel.centerYAnchor.constraint(equalTo: emailNotCheckIcon.centerYAnchor)
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
        settingTableView.register(AAppVersionCell.self, forCellReuseIdentifier: AAppVersionCell.cellId)
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

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            textField.layer.borderColor = UIColor.black.withAlphaComponent(0).cgColor
        }
        switch textField.tag {
            case 0:
                guard let newUserName = textField.text,
                      !newUserName.isEmpty else {
                    userNameView.text = manager.userInfo.userName
                    return
                }
                manager.userInfo.userName = newUserName
            case 1:
                guard let newEmail = textField.text,
                      newEmail.isValidEmail() else {
                    emailView.text = manager.userInfo.emailAddress
                    return
                }
                textField.resignFirstResponder()
                let cancelAction = UIAlertAction(title: "取消", style: .cancel)
                let updateAction = UIAlertAction(title: "更新", style: .default) { [weak self] _ in
                    guard let self else { return }
                    let loadingVC = XOLoadingViewController(title: "發送確認信中", info: "正在發送更換電子郵件的確認信...")
                    loadingVC.modalPresentationStyle = .overFullScreen
                    loadingVC.modalTransitionStyle = .crossDissolve
                    present(loadingVC, animated: true)
                    manager.updateUserEmailAddress(emailAddress: newEmail, loadingVC: loadingVC)
                    emailNotCheckIcon.alpha = 1
                    emailNotCheckLabel.alpha = 1
                }
                let alertController = UIAlertController(title: "更新電子郵件", message: "每人一天提供三次更換電子郵件，請確認電子郵件正確", preferredStyle: .alert)
                alertController.addAction(cancelAction)
                alertController.addAction(updateAction)
                present(alertController, animated: true)
            default:
                break
        }
    }
}

// MARK: - Refresh
extension AccountViewController {
    @objc private func refreshAction() {
        manager.refreshView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
}
