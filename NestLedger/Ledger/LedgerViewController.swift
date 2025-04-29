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

    let manager = LedgerVCManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        manager.vc = self

        view.backgroundColor = .white
        navigationItem.title = "帳本列表"

        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension LedgerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.ledgerDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LedgerCollectionViewCell.cellId, for: indexPath) as? LedgerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = manager.ledgerDatas[indexPath.row]
        cell.config(ledgerData: data)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let ledgerDetailVC = LedgerDetailViewController(ledgerData: manager.ledgerDatas[index])
        manager.ledgerDetailVC = ledgerDetailVC
        navigationController?.pushViewController(ledgerDetailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == manager.ledgerDatas.count - 1,
           !manager.isLoading,
           manager.ledgerDatas.count < manager.ledgerIds.count {
            Task {
                do {
                    try await manager.loadMoreLedgers()
                } catch {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "獲取更多帳本失敗")
                }
            }
        }
    }
}
