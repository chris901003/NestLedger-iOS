// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension NLCalendarView {
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NLCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionViewSections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = CollectionViewSections.allCases[section]
        switch sectionType {
            case .titleSection:
                return 7
            case .dateSection:
                return getNumberOfDayCells()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = CollectionViewSections.allCases[indexPath.section]
        switch sectionType {
            case .titleSection:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NLCTitleCell.cellId, for: indexPath) as? NLCTitleCell else {
                    return UICollectionViewCell()
                }
                cell.config(indexPath.row)
                return cell
            case .dateSection:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NLCDateCell.cellId, for: indexPath) as? NLCDateCell else {
                    return UICollectionViewCell()
                }
                let cellDay = getDayCellDay(idx: indexPath.row)
                if cellDay > 0 {
                    var cellInfo = 0
                    var cellDate = calendar.dateComponents([.year, .month], from: month)
                    cellDate.day = cellDay
                    if let date = calendar.date(from: cellDate) {
                        cellInfo = delegate?.getDateInfo(date: date) ?? 0
                    }
                    cell.config(date: cellDay > 0 ? "\(cellDay)" : "", amount: cellInfo)
                    cell.isSelected(isDaySelected(idx: indexPath.row))
                } else {
                    cell.config(date: "", amount: 0)
                    cell.isSelected(false)
                }
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = CollectionViewSections.allCases[indexPath.section]
        switch sectionType {
            case .titleSection:
                return
            case .dateSection:
                guard getDayCellDay(idx: indexPath.row) > 0 else { return }
                let day = getDayCellDay(idx: indexPath.row)
                var currentDate = calendar.dateComponents([.year, .month], from: month)
                currentDate.day = day
                if let selectedDate = calendar.date(from: currentDate) {
                    selectedDay = selectedDate
                    delegate?.didSelectDate(date: selectedDate)
                    collectionView.reloadData()
                }
        }
    }
}

