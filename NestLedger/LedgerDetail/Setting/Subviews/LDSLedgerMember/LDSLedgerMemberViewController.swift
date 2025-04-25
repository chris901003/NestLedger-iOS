// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/4/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LDSLedgerMemberViewController: UIViewController {
    let manager: LDSLedgerMemberManager

    let addNewMemberView = LDSLMAddNewMemberView()
    let tableView = UITableView()

    init(ledgerId: String) {
        manager = LDSLedgerMemberManager(ledgerId: ledgerId)
        super.init(nibName: nil, bundle: nil)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        manager.vc = self

        view.backgroundColor = .white
        navigationItem.title = "帳目成員"

        addNewMemberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddNewMemberAction)))
        addNewMemberView.isUserInteractionEnabled = true

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    private func layout() {
        view.addSubview(addNewMemberView)
        addNewMemberView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNewMemberView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addNewMemberView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addNewMemberView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addNewMemberView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(LDSLMCell.self, forCellReuseIdentifier: LDSLMCell.cellId)
    }
}

extension LDSLedgerMemberViewController {
    @objc private func tapAddNewMemberAction() {
        let enterNewMemberVC = LDSLMEnterNewMemberViewController()
        // overCurrentContext => 保持可以看到背後的 view，但是只會覆蓋父 view 的畫面，假設父 view 不是全畫面的則現在的 view 也不會是全畫面
        // overFullScreen => 保持可以看到背後的 view，會將當前的 view 覆蓋整個畫面
        enterNewMemberVC.modalPresentationStyle = .overFullScreen
        enterNewMemberVC.modalTransitionStyle = .crossDissolve
        //definesPresentationContext => 當現在在 NavigationController 當中並且使用 overCurrentContext 時會保留 NavigationItem 的部分
        // definesPresentationContext = true
        enterNewMemberVC.delegate = manager
        present(enterNewMemberVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSLedgerMemberViewController {
    fileprivate enum SectionType: String, CaseIterable {
        case member = "帳目成員"
        case invite = "正在邀請"
    }
}

extension LDSLedgerMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = SectionType.allCases[section]
        switch type {
            case .member:
                return manager.userInfos.count
            case .invite:
                return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SectionType.allCases[section].rawValue
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SectionType.allCases[indexPath.section]
        switch type {
            case .member:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSLMCell.cellId, for: indexPath) as? LDSLMCell else { return UITableViewCell() }
                cell.delegate = manager
                let data = manager.userInfos[indexPath.row]
                Task {
                    let avatar = await manager.getUserAvatar(userId: data.id)
                    await MainActor.run { cell.config(avatar: avatar, userName: data.userName, userId: data.id) }
                }
                return cell
            case .invite:
                let cell = UITableViewCell()
                cell.textLabel?.text = "ABC"
                return cell
        }
    }
}
