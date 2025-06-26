// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class LedgerSplitDetailViewController: UIViewController {
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
    }

    private func layout() {
        
    }
}
