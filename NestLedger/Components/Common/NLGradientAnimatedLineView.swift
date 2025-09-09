// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/9/9.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

final class NLGradientAnimatedLineView: UIView {

    enum Direction { case leftToRight, rightToLeft }

    // 保留狀態，讓旋轉/版面改變時能復原
    private var progress: CGFloat = 0.0          // 0 ~ 1
    private var currentDirection: Direction = .leftToRight

    // 底線（灰）
    private let backgroundLine = CALayer()
    // 前景（黑），用 mask 露出
    private let foregroundLayer = CAGradientLayer()
    private let maskLayer = CALayer()

    // 預設高度（方便 Auto Layout 沒設高度時使用）
    override var intrinsicContentSize: CGSize { CGSize(width: UIView.noIntrinsicMetric, height: 2) }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = false
        backgroundColor = .clear

        backgroundLine.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(backgroundLine)

        // 單色也可用 CAGradientLayer（之後要做漸層也方便）
        foregroundLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor]
        foregroundLayer.startPoint = CGPoint(x: 0, y: 0.5)
        foregroundLayer.endPoint   = CGPoint(x: 1, y: 0.5)

        // 初始以 0 進度配置 mask
        maskLayer.backgroundColor = UIColor.black.cgColor
        foregroundLayer.mask = maskLayer

        layer.addSublayer(foregroundLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLine.frame  = bounds
        foregroundLayer.frame = bounds
        layoutMaskForCurrentState(animated: false)
    }

    // MARK: - 公開 API

    /// 從左到右填滿
    func fillLeftToRight(duration: TimeInterval = 0.4) {
        animate(to: 1.0, direction: .leftToRight, duration: duration)
    }

    /// 從右到左填滿
    func fillRightToLeft(duration: TimeInterval = 0.4) {
        animate(to: 1.0, direction: .rightToLeft, duration: duration)
    }

    /// 從左到右清除（變回灰）
    func clearLeftToRight(duration: TimeInterval = 0.4) {
        animate(to: 0.0, direction: .leftToRight, duration: duration)
    }

    /// 從右到左清除（變回灰）
    func clearRightToLeft(duration: TimeInterval = 0.4) {
        animate(to: 0.0, direction: .rightToLeft, duration: duration)
    }

    // MARK: - 內部實作

    private func layoutMaskForCurrentState(animated: Bool) {
        let w = bounds.width * max(0, min(1, progress))
        let h = bounds.height

        switch currentDirection {
        case .leftToRight:
            // 以左邊為錨點擴張
            maskLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
            maskLayer.position    = CGPoint(x: 0, y: h/2)
        case .rightToLeft:
            // 以右邊為錨點擴張
            maskLayer.anchorPoint = CGPoint(x: 1, y: 0.5)
            maskLayer.position    = CGPoint(x: bounds.width, y: h/2)
        }

        let newBounds = CGRect(x: 0, y: 0, width: w, height: h)
        if animated {
            // 用隱式動畫避免 Core Animation 狀態不同步
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            maskLayer.bounds = newBounds
            CATransaction.commit()
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer.bounds = newBounds
            CATransaction.commit()
        }
    }

    private func animate(to newProgress: CGFloat,
                         direction: Direction,
                         duration: TimeInterval) {
        layoutIfNeeded() // 確保有正確的 bounds
        currentDirection = direction

        // 目標寬度
        let fromWidth = maskLayer.bounds.width
        let toWidth   = bounds.width * max(0, min(1, newProgress))

        // 依方向設定錨點 & 位置（只在切換方向時會有位移）
        switch direction {
        case .leftToRight:
            maskLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
            maskLayer.position    = CGPoint(x: 0, y: bounds.height/2)
        case .rightToLeft:
            maskLayer.anchorPoint = CGPoint(x: 1, y: 0.5)
            maskLayer.position    = CGPoint(x: bounds.width, y: bounds.height/2)
        }

        // 用 CABasicAnimation 只動「寬度」
        let anim = CABasicAnimation(keyPath: "bounds.size.width")
        anim.fromValue = fromWidth
        anim.toValue   = toWidth
        anim.duration  = duration
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode  = .forwards
        anim.isRemovedOnCompletion = false

        // 先把最終值寫入模型層，避免之後 layout 或多次播放不同步
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        var b = maskLayer.bounds
        b.size.width = toWidth
        maskLayer.bounds = b
        CATransaction.commit()

        maskLayer.add(anim, forKey: "width")

        // 更新狀態，供下次 layout 使用
        progress = max(0, min(1, newProgress))
    }
}
