// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension MCalendarView {
    enum CollectionViewSections: CaseIterable {
        case titleSection
        case dateSection

        var getSectionLayoutConfig: NSCollectionLayoutSection {
            get {
                switch self {
                    case .titleSection:
                        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0), heightDimension: .fractionalHeight(1.0))
                        let item = NSCollectionLayoutItem(layoutSize: itemSize)

                        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
                        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                        let section = NSCollectionLayoutSection(group: group)
                        return section
                    case .dateSection:
                        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0), heightDimension: .fractionalWidth(1.0 / 7.0))
                        let item = NSCollectionLayoutItem(layoutSize: itemSize)

                        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0 / 7.0))
                        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                        group.interItemSpacing = .fixed(2)

                        let section = NSCollectionLayoutSection(group: group)
                        section.interGroupSpacing = 2
                        return section
                }
            }
        }
    }
}

class MCalendarView: UIView {
    let yearMonthLabel = UILabel()
    let backIcon = UIImageView()
    let forwardIcon = UIImageView()
    var collectionView: UICollectionView = {
        var layout = UICollectionViewCompositionalLayout { sectionIdx, _ in
            CollectionViewSections.allCases[sectionIdx].getSectionLayoutConfig
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(MCDateCell.self, forCellWithReuseIdentifier: MCDateCell.cellId)
        collectionView.register(MCTitleCell.self, forCellWithReuseIdentifier: MCTitleCell.cellId)

        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    var selectedDay = Date.now

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
//        backgroundColor = .systemGray6
        yearMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: Date.now)
        yearMonthLabel.textColor = .black
        yearMonthLabel.font = .systemFont(ofSize: 16, weight: .bold)
        yearMonthLabel.numberOfLines = 1

        backIcon.image = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        backIcon.contentMode = .scaleAspectFit
        backIcon.isUserInteractionEnabled = true
        backIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousMonthAction)))

        forwardIcon.image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        forwardIcon.contentMode = .scaleAspectFit
        forwardIcon.isUserInteractionEnabled = true
        forwardIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextMonthAction)))

        collectionView.dataSource = self
    }

    private func layout() {
        addSubview(yearMonthLabel)
        yearMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearMonthLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            yearMonthLabel.topAnchor.constraint(equalTo: topAnchor)
        ])

        addSubview(forwardIcon)
        forwardIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forwardIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            forwardIcon.topAnchor.constraint(equalTo: yearMonthLabel.topAnchor),
            forwardIcon.bottomAnchor.constraint(equalTo: yearMonthLabel.bottomAnchor),
            forwardIcon.widthAnchor.constraint(equalTo: forwardIcon.heightAnchor)
        ])

        addSubview(backIcon)
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backIcon.trailingAnchor.constraint(equalTo: forwardIcon.leadingAnchor, constant: -8),
            backIcon.heightAnchor.constraint(equalTo: forwardIcon.heightAnchor),
            backIcon.widthAnchor.constraint(equalTo: backIcon.heightAnchor)
        ])

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: yearMonthLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension MCalendarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionViewSections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = CollectionViewSections.allCases[section]
        switch sectionType {
            case .titleSection:
                return 7
            case .dateSection:
                return 31
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = CollectionViewSections.allCases[indexPath.section]
        switch sectionType {
            case .titleSection:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MCTitleCell.cellId, for: indexPath) as? MCTitleCell else {
                    return UICollectionViewCell()
                }
                cell.config(indexPath.row)
                return cell
            case .dateSection:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MCDateCell.cellId, for: indexPath) as? MCDateCell else {
                    return UICollectionViewCell()
                }
                cell.config(date: "\(indexPath.row + 1)")
                return cell
        }
    }
}

// MARK: - Utility
extension MCalendarView {
    @objc private func previousMonthAction() {
        print("✅ Previous Month")
    }

    @objc private func nextMonthAction() {
        print("✅ Next Month")
    }
}
