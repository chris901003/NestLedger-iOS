// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/1.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

extension LSDMemberViewController {
    enum Sections: String {
        case join = "已加入"
        case waitingJoin = "等待加入"
    }
}

class LSDMemberViewController: UIViewController {
    let titleLabel = UILabel()
    let tableView = UITableView()
    let addButton = XOPaddedImageView(
        padding: .init(top: 12, left: 12, bottom: 12, right: 12),
        image: UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    )

    let ledgerSplitDetailStore: LedgerSplitDetailStore
    let manager: LSDMemberManager
    let sections: [Sections] = [.join, .waitingJoin]

    init(store: LedgerSplitDetailStore) {
        ledgerSplitDetailStore = store
        self.manager = LSDMemberManager(ledgerSplitDetailStore: ledgerSplitDetailStore)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()

        initData()
    }

    private func setup() {
        manager.vc = self
        view.backgroundColor = .white

        titleLabel.text = "分帳本成員"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 10.0
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddButtonAction)))
        addButton.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func registerCell() {
        tableView.register(LSDMemberCell.self, forCellReuseIdentifier: LSDMemberCell.cellId)
        tableView.register(LSDInviteCell.self, forCellReuseIdentifier: LSDInviteCell.cellId)
    }
}

// MARK: - Utility
extension LSDMemberViewController {
    private func initData() {
        Task {
            do {
                try await manager.loadUserInviteSend()
                await MainActor.run {
                    tableView.reloadData()
                }
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: "加載訊息失敗，請稍後再試")
            }
        }
    }

    @objc func tapAddButtonAction() {
        let addInviteVC = LSDAddInviteViewController(ledgerSplitStore: ledgerSplitDetailStore)
        addInviteVC.delegate = manager
        navigationController?.pushViewController(addInviteVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LSDMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = sections[section]
        switch cellType {
            case .join:
                return ledgerSplitDetailStore.data.userIds.count
            case .waitingJoin:
                return manager.userInviteDatas.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        section == sections.count - 1 ? UIView() : nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == sections.count - 1 ? 50 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section]
        switch cellType {
            case .join:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LSDMemberCell.cellId, for: indexPath) as? LSDMemberCell else {
                    return UITableViewCell()
                }
                let userId = ledgerSplitDetailStore.data.userIds[indexPath.row]
                cell.config(
                    ledgerSplitId: ledgerSplitDetailStore.data._id,
                    userId: userId,
                    type: .join,
                    isShowDeleteButton: userId != newSharedUserInfo.id
                )
                cell.delegate = self
                return cell
            case .waitingJoin:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LSDInviteCell.cellId, for: indexPath) as? LSDInviteCell else {
                    return UITableViewCell()
                }
                cell.config(data: manager.userInviteDatas[indexPath.row])
                cell.delegate = self
                return cell
        }
    }
}

// MARK: - LSDInviteCellDelegate
extension LSDMemberViewController: LSDMemberCellDelegate, LSDInviteCellDelegate {
    func memberCellDidTapDeleteButton(_ cell: LSDMemberCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var ledgerSplitData = ledgerSplitDetailStore.data
        ledgerSplitData.userIds.remove(at: indexPath.row)
        ledgerSplitDetailStore.update(ledgerSplitData: ledgerSplitData)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func deleteInvite(_ cell: LSDInviteCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        manager.userInviteDatas.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
