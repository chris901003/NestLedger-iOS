// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/12.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LDSCTLedgerListViewControllerDelegate: AnyObject {
    func didSelect(ledgerData: LedgerData)
}

class LDSCTLedgerListViewController: UIViewController {
    let topBarView = UIView()
    let titleLabel = UILabel()
    let tableView = UITableView()

    let manager = LDSCTLedgerManager()
    weak var delegate: LDSCTLedgerListViewControllerDelegate?
    let currentLedgerId: String

    init(ledgerId: String) {
        currentLedgerId = ledgerId
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
        manager.loadMoreLedgerData()
    }

    private func setup() {
        view.backgroundColor = .white
        manager.vc = self

        topBarView.backgroundColor = .systemGray4
        topBarView.layer.cornerRadius = 3.0

        titleLabel.text = "帳本列表"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }

    private func layout() {
        view.addSubview(topBarView)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            topBarView.widthAnchor.constraint(equalToConstant: 45),
            topBarView.heightAnchor.constraint(equalToConstant: 6),
            topBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }

    private func registerCell() {
        tableView.register(LDSCTLedgerCell.self, forCellReuseIdentifier: LDSCTLedgerCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSCTLedgerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.ledgerData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSCTLedgerCell.cellId, for: indexPath) as? LDSCTLedgerCell else {
            return UITableViewCell()
        }
        let data = manager.ledgerData[indexPath.row]
        let title = data.title.starts(with: "[Main]") ? "我的帳本" : data.title
        cell.config(ledgerTitle: title)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == manager.ledgerData.count - 1,
              manager.ledgerData.count < newSharedUserInfo.ledgerIds.count else { return }
        manager.loadMoreLedgerData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = manager.ledgerData[indexPath.row]
        if data._id == currentLedgerId {
            let okAction = UIAlertAction(title: "確定", style: .default)
            let alertController = UIAlertController(title: "選擇失敗", message: "無法選取當前帳本", preferredStyle: .alert)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return
        }
        delegate?.didSelect(ledgerData: data)
        dismiss(animated: true)
    }
}
