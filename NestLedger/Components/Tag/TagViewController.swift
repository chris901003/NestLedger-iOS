// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/6.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

protocol TagViewControllerDelegate: AnyObject {
    func selectedTag(vc: UIViewController, data: TagData)
}

enum TagVCType: String {
    case selectTag = "選擇標籤"
}

class TagViewController: UIViewController {
    let tagCellId = "TagCellId"
    let newTagCellId = "NewTagCellId"

    let type: TagVCType

    let topBar = UIView()
    let titleLabel = UILabel()
    let sepLine = UIView()

    let searchBar = XOSearchBarView()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    let manager = TagManager()
    weak var delegate: TagViewControllerDelegate?

    init(type: TagVCType) {
        self.type = type
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
    }

    private func setup() {
        manager.vc = self

        view.backgroundColor = .white

        topBar.backgroundColor = .systemGray5
        topBar.layer.cornerRadius = 2

        titleLabel.text = type.rawValue
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center

        sepLine.backgroundColor = .systemGray4

        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
            topBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 4),
            topBar.widthAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(sepLine)
        sepLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            sepLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sepLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sepLine.heightAnchor.constraint(equalToConstant: 2)
        ])

        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: sepLine.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCell() {
        tableView.register(TagCell.self, forCellReuseIdentifier: tagCellId)
        tableView.register(NewTagCell.self, forCellReuseIdentifier: newTagCellId)
    }
}

// MARK: - XOSearchBarViewDelegate
extension TagViewController: XOSearchBarViewDelegate {
    func searchAction(text: String) {
        manager.search = text.isEmpty ? nil : text
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TagViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SectionType.allCases[section].sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SectionType.allCases[section].rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SectionType.allCases[section] == .newTag ? 1 : manager.showTags.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !manager.isLoading,
           !manager.isEnd,
           SectionType.allCases[indexPath.section] == .existTag,
           indexPath.row == manager.showTags.count - 1 {
            Task {
                do {
                    try await manager.fetchMoreLedgerTags()
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "加載更多標籤失敗")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SectionType.allCases[indexPath.section]
        switch type {
            case .existTag:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: tagCellId, for: indexPath) as? TagCell else {
                    return UITableViewCell()
                }
                let data = manager.showTags[indexPath.row]
                cell.config(color: data.getColor, label: data.label)
                return cell
            case .newTag:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: newTagCellId, for: indexPath) as? NewTagCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
                return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = SectionType.allCases[indexPath.section]
        guard type == .existTag else { return }
        delegate?.selectedTag(vc: self, data: manager.showTags[indexPath.row])
    }
}

// MARK: - NLNeedPresent
extension TagViewController: NLNeedPresent {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
}

// MARK: - NewTagCellDelegate
extension TagViewController: NewTagCellDelegate {
    func sendNewTag(data: TagData) {
        Task {
            let result = await manager.createTag(tag: data)
            if result {
                await MainActor.run { delegate?.selectedTag(vc: self, data: data) }
            }
        }
    }
}
