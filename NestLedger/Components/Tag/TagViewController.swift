// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/6.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import xxooooxxCommonUI

enum TagVCType: String {
    case selectTag = "選擇標籤"
}

class TagViewController: UIViewController {
    let type: TagVCType

    let topBar = UIView()
    let titleLabel = UILabel()
    let sepLine = UIView()

    let searchBar = XOSearchBarView()

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
    }

    private func setup() {
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
    }
}

// MARK: - XOSearchBarViewDelegate
extension TagViewController: XOSearchBarViewDelegate {
    func searchAction(text: String) {
        print("✅ Search: \(text)")
    }
}
