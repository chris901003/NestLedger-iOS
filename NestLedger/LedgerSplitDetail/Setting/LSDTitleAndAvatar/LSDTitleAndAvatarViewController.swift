// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/26.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LSDTitleAndAvatarViewController: UIViewController {
    let manager: LSDTitleAndAvatarManager
    let avatarView = UIImageView()
    let titleTextField = XOTextField(.init(top: 12, left: 8, bottom: 12, right: 8))

    init(ledgerSplitData: LedgerSplitData) {
        manager = LSDTitleAndAvatarManager(ledgerSplitData: ledgerSplitData)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        Task { await manager.loadAvatar() }
    }

    private func setup() {
        manager.vc = self
        navigationItem.title = "分帳本名稱與頭像"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(tapSaveAction))

        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackground)))

        avatarView.image = UIImage(named: "LedgerSplitIcon")
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 50
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAvatarAction)))
        avatarView.isUserInteractionEnabled = true

        titleTextField.placeholder = "分帳本名稱"
        titleTextField.text = manager.ledgerSplitData.title
        titleTextField.font = .systemFont(ofSize: 16, weight: .semibold)
        titleTextField.backgroundColor = .systemGray5
        titleTextField.layer.cornerRadius = 15.0
        titleTextField.textAlignment = .center
        titleTextField.delegate = self
    }
   
    private func layout() {
        view.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100)
        ])

        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])
    }

    @objc private func tapBackground() {
        titleTextField.resignFirstResponder()
    }

    @objc private func tapSaveAction() {
        Task {
            do {
                let response = try await manager.save()
                await MainActor.run { _ = navigationController?.popViewController(animated: true) }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LSDTitleAndAvatarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        manager.newTitle = textField.text ?? ""
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension LSDTitleAndAvatarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func tapAvatarAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatarView.image = image
            manager.newAvatar = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
