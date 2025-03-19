// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/19.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

class LedgerViewController: UIViewController {
    let searchBarView = XOSearchBarView()
    let collectionView: UICollectionView = {
        var layout: UICollectionViewCompositionalLayout = {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(24)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            return UICollectionViewCompositionalLayout(section: section)
        }()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LedgerCollectionViewCell.self, forCellWithReuseIdentifier: LedgerCollectionViewCell.cellId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "帳本列表"

        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
    }

    private func layout() {
        view.addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ])

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension LedgerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LedgerCollectionViewCell.cellId, for: indexPath) as? LedgerCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
