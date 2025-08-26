// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import Alamofire

class AAppVersionCell: UITableViewCell {
    static let cellId = "AAppVersionCellId"

    let titleLabel = UILabel()
    let loadingView = UIActivityIndicatorView(style: .medium)
    let versionLabel = UILabel()
    let infoLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        Task {
            let isNeedUpdate = await checkNeedUpdate()
            await MainActor.run {
                loadingView.stopAnimating()
                loadingView.alpha = 0
                if isNeedUpdate {
                    infoLabel.alpha = 1
                    infoLabel.isUserInteractionEnabled = true
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        titleLabel.text = "版本"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .black

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "未知版本"
        versionLabel.text = version
        versionLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        versionLabel.textColor = .secondaryLabel

        loadingView.startAnimating()

        infoLabel.text = "更新"
        infoLabel.textColor = .systemBlue
        infoLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        infoLabel.alpha = 0
        infoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUpdate)))
    }

    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])

        contentView.addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            versionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            versionLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])

        contentView.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loadingView.trailingAnchor.constraint(equalTo: versionLabel.leadingAnchor, constant: -6)
        ])

        contentView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: versionLabel.leadingAnchor, constant: -6)
        ])
    }

    @objc private func tapUpdate() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6745515676") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Fetch App Store Version
extension AAppVersionCell {
    struct AppStoreResponse: Codable {
        let resultCount: Int
        let results: [AppStoreData]
    }

    struct AppStoreData: Codable {
        let version: String
    }

    private func checkNeedUpdate() async -> Bool {
        let response = await AF.request("https://itunes.apple.com/lookup?bundleId=com.hungyen.NestLedger")
            .serializingData()
            .response
        switch response.result {
            case .success(let data):
                guard let response = try? NewAPIManager.decoder.decode(AppStoreResponse.self, from: data),
                      let version = response.results.first?.version,
                      let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                      version.isNewer(than: currentVersion) else { return false }
                return true
            case .failure(let error):
                return false
        }
    }
}

extension String {
    func compareVersion(to other: String) -> ComparisonResult {
        let parts1 = self.split(separator: ".").compactMap { Int($0) }
        let parts2 = other.split(separator: ".").compactMap { Int($0) }
        let count = max(parts1.count, parts2.count)

        for i in 0..<count {
            let num1 = i < parts1.count ? parts1[i] : 0
            let num2 = i < parts2.count ? parts2[i] : 0
            if num1 < num2 { return .orderedAscending }
            if num1 > num2 { return .orderedDescending }
        }
        return .orderedSame
    }

    func isNewer(than other: String) -> Bool {
        return self.compareVersion(to: other) == .orderedDescending
    }

    func isOlder(than other: String) -> Bool {
        return self.compareVersion(to: other) == .orderedAscending
    }

    func isSameVersion(as other: String) -> Bool {
        return self.compareVersion(to: other) == .orderedSame
    }
}
