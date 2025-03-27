// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LedgerDetailViewController: UIViewController {
    let manager: LedgerDetailManager

    let backButton = XONavigationBackButtonView(title: "返回")
    let titleLabel = UILabel()
    let avatarListView: UICollectionView = {
        var layout: UICollectionViewCompositionalLayout = {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 8), heightDimension: .fractionalWidth(1.0 / 8))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 4
            section.orthogonalScrollingBehavior = .continuous
            return UICollectionViewCompositionalLayout(section: section)
        }()
        layout.configuration.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AvatarCollectionViewCell.self, forCellWithReuseIdentifier: AvatarCollectionViewCell.cellId)
        return collectionView
    }()
    let incomeExpenseView = LDIncomeExpenseView()

    weak var avatarListViewHeightConstraint: NSLayoutConstraint?

    init(ledgerData: LedgerData) {
        manager = LedgerDetailManager(ledgerData: ledgerData)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarListViewHeightConstraint?.constant = view.bounds.width / 8
    }

    private func setup() {
        manager.vc = self

        view.backgroundColor = .white
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backAction)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        navigationItem.titleView = titleLabel
        titleLabel.text = manager.ledgerTitle
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 1

        avatarListView.dataSource = self

        incomeExpenseView.config(income: manager.ledgerData.totalIncome, expense: manager.ledgerData.totalExpense)
    }

    private func layout() {
        view.addSubview(avatarListView)
        avatarListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            avatarListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarListView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        avatarListViewHeightConstraint = avatarListView.heightAnchor.constraint(equalToConstant: 30)
        avatarListViewHeightConstraint?.isActive = true

        view.addSubview(incomeExpenseView)
        incomeExpenseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeExpenseView.topAnchor.constraint(equalTo: avatarListView.bottomAnchor, constant: 8),
            incomeExpenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            incomeExpenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension LedgerDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.userInfos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCollectionViewCell.cellId, for: indexPath) as? AvatarCollectionViewCell else {
            return UICollectionViewCell()
        }
        let userId = manager.userInfos[indexPath.row].id
        Task {
            let avatar = await manager.getUserAvatar(userId: userId)
            await MainActor.run { cell.config(image: avatar) }
        }
        return cell
    }
}
