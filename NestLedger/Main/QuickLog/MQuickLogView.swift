// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MQuickLogView: UIView {
    let plus1 = MQLPlusButtonView(title: "+1", value: 1)
    let plus10 = MQLPlusButtonView(title: "+10", value: 10)
    let plus100 = MQLPlusButtonView(title: "+100", value: 100)
    let plus1000 = MQLPlusButtonView(title: "+1000", value: 1000)

    let totalIcon = UIImageView()
    let totalLabel = UITextField()

    var totalValue = 0 {
        didSet {
            print("✅ New value: \(totalValue)")
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self else { return }
                totalLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                totalLabel.text = "\(totalValue)"
            }) { _ in
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.totalLabel.transform = .identity
                }
            }
        }
    }

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 18
        let width: CGFloat = (bounds.width - space * 3) / 4
        let height: CGFloat = width / 1.5

        NSLayoutConstraint.activate([
            plus1.topAnchor.constraint(equalTo: topAnchor),
            plus1.leadingAnchor.constraint(equalTo: leadingAnchor),
            plus1.widthAnchor.constraint(equalToConstant: width),
            plus1.heightAnchor.constraint(equalToConstant: height)
        ])
        plus1.layer.shadowPath = UIBezierPath(rect: plus1.bounds).cgPath

        NSLayoutConstraint.activate([
            plus10.topAnchor.constraint(equalTo: topAnchor),
            plus10.leadingAnchor.constraint(equalTo: plus1.trailingAnchor, constant: space),
            plus10.widthAnchor.constraint(equalToConstant: width),
            plus10.heightAnchor.constraint(equalToConstant: height)
        ])
        plus10.layer.shadowPath = UIBezierPath(rect: plus10.bounds).cgPath

        NSLayoutConstraint.activate([
            plus100.topAnchor.constraint(equalTo: topAnchor),
            plus100.leadingAnchor.constraint(equalTo: plus10.trailingAnchor, constant: space),
            plus100.widthAnchor.constraint(equalToConstant: width),
            plus100.heightAnchor.constraint(equalToConstant: height)
        ])
        plus100.layer.shadowPath = UIBezierPath(rect: plus100.bounds).cgPath

        NSLayoutConstraint.activate([
            plus1000.topAnchor.constraint(equalTo: topAnchor),
            plus1000.leadingAnchor.constraint(equalTo: plus100.trailingAnchor, constant: space),
            plus1000.widthAnchor.constraint(equalToConstant: width),
            plus1000.heightAnchor.constraint(equalToConstant: height)
        ])
        plus1000.layer.shadowPath = UIBezierPath(rect: plus1000.bounds).cgPath

        totalLabel.text = "\(totalValue)"
        totalLabel.textColor = .black
        totalLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        totalLabel.keyboardType = .numberPad
    }

    private func setup() {
//        backgroundColor = .systemGray6
        setupButton(plusView: plus1)
        setupButton(plusView: plus10)
        setupButton(plusView: plus100)
        setupButton(plusView: plus1000)

        totalIcon.image = UIImage(named: "coin")
        totalIcon.contentMode = .scaleAspectFit
    }

    private func setupButton(plusView: MQLPlusButtonView) {
        let plusButtonTextColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1)
        let plusButtonBackgroundColor = UIColor(red: 1, green: 245 / 255, blue: 222 / 255, alpha: 1)

        plusView.backgroundColor = plusButtonBackgroundColor
        plusView.label.textColor = plusButtonTextColor
        plusView.layer.cornerRadius = 10.0
        plusView.isUserInteractionEnabled = true
        plusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))

        plusView.layer.shadowColor = UIColor.black.cgColor
        plusView.layer.shadowOpacity = 0.1
        plusView.layer.shadowOffset = .zero
        plusView.layer.shadowRadius = 5
        plusView.layer.masksToBounds = false
    }

    private func layout() {
        addSubview(plus1)
        plus1.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plus10)
        plus10.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plus100)
        plus100.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plus1000)
        plus1000.translatesAutoresizingMaskIntoConstraints = false

        addSubview(totalIcon)
        totalIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalIcon.topAnchor.constraint(equalTo: plus1.bottomAnchor, constant: 18),
            totalIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            totalIcon.heightAnchor.constraint(equalToConstant: 35),
            totalIcon.widthAnchor.constraint(equalToConstant: 35)
        ])

        addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: totalIcon.trailingAnchor, constant: 12),
            totalLabel.centerYAnchor.constraint(equalTo: totalIcon.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

extension MQuickLogView {
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? MQLPlusButtonView else { return }
        UIView.animate(withDuration: 0.1, animations: {
            tappedView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                tappedView.transform = .identity
            }
        }

        totalValue += tappedView.value
    }
}
