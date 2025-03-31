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

    var collectionViewHeightConstraint: NSLayoutConstraint?

    let manager: MCalendarManager

    init(ledgerId: String) {
        manager = MCalendarManager(ledgerId: ledgerId)
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewHeightConstraint?.constant = collectionView.contentSize.height
    }

    private func setup() {
        manager.vc = self

        yearMonthLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: manager.selectedDay)
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
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
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
            forwardIcon.centerYAnchor.constraint(equalTo: yearMonthLabel.centerYAnchor),
            forwardIcon.widthAnchor.constraint(equalToConstant: 20),
            forwardIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(backIcon)
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backIcon.trailingAnchor.constraint(equalTo: forwardIcon.leadingAnchor, constant: -8),
            backIcon.centerYAnchor.constraint(equalTo: forwardIcon.centerYAnchor),
            backIcon.widthAnchor.constraint(equalToConstant: 20),
            backIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: yearMonthLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightConstraint?.isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension MCalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionViewSections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = CollectionViewSections.allCases[section]
        switch sectionType {
            case .titleSection:
                return 7
            case .dateSection:
                return manager.daysInMonth() ?? 30
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
                let date = manager.getCellDate(index: indexPath.row) ?? Date.now
                cell.date = date
                let dateString = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_dd, date: date)
                cell.config(date: manager.getCollectionViewDate(index: indexPath.row), amount: manager.dayAmount[dateString, default: 0])
                cell.isSelected(cell.date == Calendar.current.startOfDay(for: Date.now))
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = CollectionViewSections.allCases[indexPath.section]
        switch sectionType {
            case .titleSection:
                return
            case .dateSection:
                let date = manager.getCollectionViewDate(index: indexPath.row)
                if date == "" { return }
        }
    }
}

// MARK: - Utility
extension MCalendarView {
    @objc private func previousMonthAction() {
        let (year, month) = manager.getYearAndMonth()
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year - (month == 1 ? 1 : 0)
        components.month = month == 1 ? 12 : month - 1
        components.day = 1
        if let date = calendar.date(from: components) {
            manager.selectedDay = date
        }
    }

    @objc private func nextMonthAction() {
        let (year, month) = manager.getYearAndMonth()
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year + (month == 12 ? 1 : 0)
        components.month = month == 12 ? 1 : month + 1
        components.day = 1
        if let date = calendar.date(from: components) {
            manager.selectedDay = date
        }
    }
}
