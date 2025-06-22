// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/6/22.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class NLCircleView: UIView {
    private var shapeLayer: CAShapeLayer?
    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer?.removeFromSuperlayer()

        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)

        let layer = CAShapeLayer()
        layer.path = circlePath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.blue.cgColor
        layer.lineWidth = 3.0
        layer.lineDashPattern = [6, 3]

        self.layer.addSublayer(layer)
        shapeLayer = layer
    }
}
