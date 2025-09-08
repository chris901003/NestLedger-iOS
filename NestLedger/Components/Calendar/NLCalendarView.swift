// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/7.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol NLCalendarViewDelegate: AnyObject {
    func getDateInfo(date: Date) -> Int
    func didSelectDate(date: Date)
}

class NLCalendarView: UIView {
    let titleLabel = UILabel()
    let leftButton = UIImageView()
    let rightButton = UIImageView()
    var collectionView: UICollectionView = {
        var layout = UICollectionViewCompositionalLayout { sectionIdx, _ in
            CollectionViewSections.allCases[sectionIdx].getSectionLayoutConfig
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NLCTitleCell.self, forCellWithReuseIdentifier: NLCTitleCell.cellId)
        collectionView.register(NLCDateCell.self, forCellWithReuseIdentifier: NLCDateCell.cellId)

        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    var collectionViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: NLCalendarViewDelegate?

    let calendar = Calendar.current
    var month: Date {
        didSet { collectionView.reloadData() }
    }
    var selectedDay: Date

    init() {
        month = NLCalendarView.firstDayOfMonth(date: .now)
        selectedDay = NLCalendarView.dayStart(date: .now)
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }

    private func setup() {
        titleLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: month)
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        leftButton.contentMode = .scaleAspectFit
        leftButton.image = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        leftButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLeftButtonAction)))
        leftButton.isUserInteractionEnabled = true

        rightButton.contentMode = .scaleAspectFit
        rightButton.image = UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        rightButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRightButtonAction)))
        rightButton.isUserInteractionEnabled = true

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])

        addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightButton.widthAnchor.constraint(equalToConstant: 20),
            rightButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            leftButton.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -8),
            leftButton.widthAnchor.constraint(equalToConstant: 20),
            leftButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 10)
        collectionViewHeightConstraint.isActive = true
    }
}

// MARK: - Utility
extension NLCalendarView {
    @objc private func tapLeftButtonAction() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: month) {
            month = previousMonth
        }
        titleLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: month)
    }

    @objc private func tapRightButtonAction() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: month) {
            month = nextMonth
        }
        titleLabel.text = DateFormatterManager.shared.dateFormat(type: .yyyy_MM_ch, date: month)
    }
}
