// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension ImageQualitySettingViewController {
    enum QualityType: String {
        case low = "低"
        case medieum = "中"
        case high = "高"

        static func getType(value: Double) -> Self {
            switch value {
                case low.value:
                    return .low
                case medieum.value:
                    return .medieum
                case high.value:
                    return .high
                default:
                    return .medieum
            }
        }

        var information: String {
            switch self {
                case .low:
                    return "較低的畫質，節省網路流量以及提高載入速度"
                case .medieum:
                    return "是個平衡畫質與速度的選項"
                case .high:
                    return "原始圖片上傳，需較多流量同時載入速度可能降低"
            }
        }

        var value: Double {
            switch self {
                case .low:
                    return 0.1
                case .medieum:
                    return 0.2
                case .high:
                    return 0.3
            }
        }
    }
}

protocol ImageQualitySettingVCDelegate: AnyObject {
    func selectedQuality(type: ImageQualitySettingViewController.QualityType)
}

class ImageQualitySettingViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    var selectedType: QualityType
    let rows: [QualityType] = [.low, .medieum, .high]

    weak var delegate: ImageQualitySettingVCDelegate?

    init(type: QualityType) {
        self.selectedType = type
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
        navigationItem.title = "照片畫質設定"

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ImageQualitySettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let type = rows[indexPath.row]
        cell.textLabel?.text = type.rawValue
        cell.accessoryType = type == selectedType ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        selectedType.information
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedType = rows[indexPath.row]
        delegate?.selectedQuality(type: selectedType)
        tableView.reloadData()
    }
}
