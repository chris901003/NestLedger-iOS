// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/13.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LDSCTTargetTagViewDelegate: AnyObject {
    func getNumberOfTargetTags() -> Int
    func getTagData(at index: Int) -> (tagData: TagData, isDeletable: Bool)
    func loadMoreTargetTag()
    func removeTag(tagData: TagData)
}

class LDSCTTargetTagView: UIView {
    let titleLabel = UILabel()
    let contentView = UIView()
    let tableView = UITableView()

    let hintLabel = UILabel()

    var isLoading = true
    var isEnd = false
    weak var delegate: LDSCTTargetTagViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
        layout()
        registerCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel.text = "目標帳本標籤"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 2.5
        contentView.layer.borderColor = UIColor.systemGray5.cgColor

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false

        hintLabel.text = "請先選擇目標帳本"
        hintLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        hintLabel.textColor = .secondaryLabel
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        contentView.addSubview(hintLabel)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hintLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            hintLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(LDSCTTagCell.self, forCellReuseIdentifier: LDSCTTagCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSCTTargetTagView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.getNumberOfTargetTags() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSCTTagCell.cellId, for: indexPath) as? LDSCTTagCell,
              let data = delegate?.getTagData(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.config(tagData: data.tagData, isDeletable: data.isDeletable)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isEnd, !isLoading,
              indexPath.row == (delegate?.getNumberOfTargetTags() ?? 0) - 1 else { return }
        isLoading = true
        delegate?.loadMoreTargetTag()
    }
}

extension LDSCTTargetTagView {
    func hideHint() {
        hintLabel.alpha = 0
    }
}

// MARK: - LDSCTTagCellDelegate
extension LDSCTTargetTagView: LDSCTTagCellDelegate {
    func tapDeleteButton(in cell: LDSCTTagCell) {
        guard let tagData = cell.tagData,
              let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.removeTag(tagData: tagData)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
}
