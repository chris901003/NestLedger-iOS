// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import Combine

protocol LedgerSplitDetailViewControllerDelegate: AnyObject {
    func updateLedgerSplit(data: LedgerSplitData, avatar: UIImage)
}

class LedgerSplitDetailViewController: UIViewController {
    let settingButton = UIImageView()

    let ledgerSplitDetailStore: LedgerSplitDetailStore
    let manager: LedgerSplitDetailManager
    var cancellables: Set<AnyCancellable> = []
    weak var delegate: LedgerSplitDetailViewControllerDelegate?

    init(ledgerSplitData: LedgerSplitData) {
        ledgerSplitDetailStore = LedgerSplitDetailStore(data: ledgerSplitData, avatar: UIImage(named: "LedgerSplitIcon")!)
        manager = LedgerSplitDetailManager(dataStore: ledgerSplitDetailStore)
        super.init(nibName: nil, bundle: nil)
        subscribeLedgerSplitStore()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        Task { await manager.loadAvatar() }
    }

    private func setup() {
        view.backgroundColor = .white

        ledgerSplitDetailStore.dataPublisher
            .sink { [weak self] ledgerSplitData in
                self?.navigationItem.title = ledgerSplitData.title
            }
            .store(in: &cancellables)

        settingButton.image = UIImage(systemName: "gear")
        settingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSettingAction)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
    }

    private func layout() {
        
    }
}

// MARK: - Setting
extension LedgerSplitDetailViewController: LSDSettingViewControllerDelegate {
    @objc private func tapSettingAction() {
        let settingViewController = LSDSettingViewController(ledgerSplitDetailStore: ledgerSplitDetailStore)
        settingViewController.delegate = self
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

    func leaveLedgerSplit() {
        NLNotification.sendRefreshLedgerSplitListView()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Subscribe Ledger Split Store
extension LedgerSplitDetailViewController {
    func subscribeLedgerSplitStore() {
        ledgerSplitDetailStore.dataPublisher
            .combineLatest(ledgerSplitDetailStore.avatarPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (ledgerSplitData, avatar) in
                guard let self else { return }
                delegate?.updateLedgerSplit(data: ledgerSplitData, avatar: avatar)
            }
            .store(in: &cancellables)
    }
}
