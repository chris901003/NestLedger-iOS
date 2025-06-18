// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol LDSCTCurrentTagViewDelegate: AnyObject {
    func getNumberOfCurrentTags() -> Int
    func getTagData(at index: Int) -> (tagData: TagData, isSelected: Bool)
    func loadMoreCurrentTag()
    func tag(isSelected: Bool, tagId: String)
}

class LDSCTCurrentTagView: UIView {
    let titleLabel = UILabel()
    let contentView = UIView()
    let tableView = UITableView()

    var isLoading = true
    var isEnd = false

    weak var delegate: LDSCTCurrentTagViewDelegate?

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
        titleLabel.text = "當前帳本標籤"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 2.5
        contentView.layer.borderColor = UIColor.systemGray5.cgColor

        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
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

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func registerCell() {
        tableView.register(LDSCTCurrentTagCell.self, forCellReuseIdentifier: LDSCTCurrentTagCell.cellId)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LDSCTCurrentTagView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.getNumberOfCurrentTags() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LDSCTCurrentTagCell.cellId, for: indexPath) as? LDSCTCurrentTagCell,
              let data = delegate?.getTagData(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.config(tagData: data.tagData, isSelected: data.isSelected)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoading, !isEnd,
              indexPath.row == (delegate?.getNumberOfCurrentTags() ?? 0) - 1 else { return }
        isLoading = true
        delegate?.loadMoreCurrentTag()
    }
}

// MARK: - LDSCTCurrentTagCellDelegate
extension LDSCTCurrentTagView: LDSCTCurrentTagCellDelegate {
    func tag(isSelected: Bool, tagId: String) {
        delegate?.tag(isSelected: isSelected, tagId: tagId)
    }
}
