// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LedgerSplitDetailViewController: UIViewController {
    let settingButton = UIImageView()

    let manager: LedgerSplitDetailManager

    init(ledgerSplitData: LedgerSplitData) {
        manager = LedgerSplitDetailManager(ledgerSplitData: ledgerSplitData)
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
        navigationItem.title = manager.ledgerSplitData.title

        settingButton.image = UIImage(systemName: "gear")
        settingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSettingAction)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }

    private func layout() {
        
    }

    @objc private func tapSettingAction() {
        let settingViewController = LSDSettingViewController(ledgerSplitData: manager.ledgerSplitData)
        let navigationVC = UINavigationController(rootViewController: settingViewController)
        let _50DetentId = UISheetPresentationController.Detent.Identifier("50")
        let _50Detent = UISheetPresentationController.Detent.custom(identifier: _50DetentId) { context in
            UIScreen.main.bounds.height * 0.5
        }
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [_50Detent]
        }
        present(navigationVC, animated: true)
    }
}
