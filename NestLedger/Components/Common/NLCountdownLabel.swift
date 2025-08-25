// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class NLCountdownLabel: UILabel {
    private var timer: Timer?
    private var endDate: Date?

    func startCountdown(to date: Date) {
        endDate = date
        timer?.invalidate()

        updateText()

        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateText),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func updateText() {
        guard let endDate = endDate else { return }

        let remaining = Int(endDate.timeIntervalSinceNow)
        if remaining <= 0 {
            text = "已過期"
            timer?.invalidate()
            timer = nil
        } else {
            let hours = remaining / 3600
            let minutes = (remaining % 3600) / 60
            let seconds = remaining % 60
            text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
}
