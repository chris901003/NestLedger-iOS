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

    let scrollView = UIScrollView()
    let contentView = UIView()
    let calendarView: MCalendarView
    let transactionsView = LTransactionView()

    weak var avatarListViewHeightConstraint: NSLayoutConstraint?

    init(ledgerData: LedgerData) {
        manager = LedgerDetailManager(ledgerData: ledgerData)
        calendarView = MCalendarView(ledgerId: ledgerData._id)
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
        avatarListView.alwaysBounceVertical = false

        incomeExpenseView.config(income: manager.ledgerData.totalIncome, expense: manager.ledgerData.totalExpense)

        transactionsView.delegate = self
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
            incomeExpenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            incomeExpenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: incomeExpenseView.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true

        contentView.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        calendarView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        contentView.addSubview(transactionsView)
        transactionsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionsView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            transactionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            transactionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            transactionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        transactionsView.setContentHuggingPriority(.defaultLow, for: .vertical)
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

// MARK: - NLNeedPresent
extension LedgerDetailViewController: NLNeedPresent {
    func presentVC(_ vc: UIViewController) {
        present(vc, animated: true)
    }
}
