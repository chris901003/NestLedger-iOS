// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/20.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import xxooooxxCommonUI

class LedgerVCManager {
    let newApiManager = NewAPIManager()

    var ledgerIds: [String] = newSharedUserInfo.ledgerIds
    var ledgerDatas: [LedgerData] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.vc?.collectionView.reloadData()
            }
        }
    }

    @MainActor var isLoading = false
    weak var vc: LedgerViewController?
    weak var ledgerDetailVC: LedgerDetailViewController?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveQuitLedgerNotification), name: .quitLedger, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveUpdateLedger), name: .updateLedger, object: nil)
        Task {
            do {
                try await loadMoreLedgers()
            } catch {
                XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "讀取帳本失敗")
            }
        }
    }

    func loadMoreLedgers() async throws {
        await MainActor.run { isLoading = true }
        let datas = try await withThrowingTaskGroup(of: LedgerData?.self, returning: [LedgerData].self) { group in
            let startIdx = ledgerDatas.count
            let endIdx = min(startIdx + 10, ledgerIds.count)
            for idx in startIdx..<endIdx {
                group.addTask { [weak self] in
                    guard let self else { return nil }
                    return try await newApiManager.getLedger(ledgerId: ledgerIds[idx])
                }
            }
            let results = (try await group.reduce(into: [LedgerData]()) { $0.append($1) }).compactMap { $0 }
            return results
        }
        ledgerDatas.append(contentsOf: datas)
        await MainActor.run { isLoading = false }
    }

    @objc private func receiveQuitLedgerNotification(_ notification: Notification) {
        guard let ledgerId = NLNotification.decodeQuitLedger(notification),
              let ledgerIdx = (ledgerIds.firstIndex { $0 == ledgerId }),
              let ledgerDataIdx = (ledgerDatas.firstIndex { $0._id == ledgerId }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self else { return }
            ledgerIds.remove(at: ledgerIdx)
            ledgerDatas.remove(at: ledgerDataIdx)
            vc?.collectionView.reloadData()
            vc?.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func receiveUpdateLedger(_ notification: Notification) {
        guard let ledgerData = NLNotification.decodeUpdateLedger(notification),
              let idx = (ledgerDatas.firstIndex { $0._id == ledgerData._id }) else { return }
        ledgerDatas[idx] = ledgerData
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            vc?.collectionView.reloadData()
        }
    }
}

// MARK: - CreateLedgerViewControllerDelegate
extension LedgerVCManager: CreateLedgerViewControllerDelegate {
    func createLedger(title: String) {
        if title.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XOBottomBarInformationManager.showBottomInformation(type: .info, information: "帳本名稱不可為空")
            }
            return
        }

        Task {
            do {
                let newLedgerData = try await newApiManager.createLedger(data: .init(title: title, userId: newSharedUserInfo.id))
                newSharedUserInfo = try await newApiManager.getUserInfo()
                await MainActor.run {
                    ledgerIds.append(newLedgerData._id)
                    ledgerDatas.append(newLedgerData)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    XOBottomBarInformationManager.showBottomInformation(type: .success, information: "創建帳本成功")
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    XOBottomBarInformationManager.showBottomInformation(type: .failed, information: "創建帳本失敗")
                }
            }
        }
    }
}

// MARK: - ReceiveLedgerViewControllerDelegate
extension LedgerVCManager: ReceiveLedgerViewControllerDelegate {
    func joinLedger(ledgerId: String) {
        Task {
            if let ledgerData = try? await newApiManager.getLedger(ledgerId: ledgerId) {
                ledgerIds.append(ledgerData._id)
                ledgerDatas.append(ledgerData)
            }
        }
    }
}
