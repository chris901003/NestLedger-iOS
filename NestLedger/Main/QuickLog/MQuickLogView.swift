// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/23.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MQuickLogView: UIView {
    let titleInputView = MQLTitleInputView()

    let plus1 = MQLPlusButtonView(title: "+1", value: 1)
    let plus10 = MQLPlusButtonView(title: "+10", value: 10)
    let plus100 = MQLPlusButtonView(title: "+100", value: 100)
    let plus1000 = MQLPlusButtonView(title: "+1000", value: 1000)

    let totalView = UIView()
    let totalIcon = UIImageView()
    let totalLabel = UITextField()

    let incomeExpenditureSelectView = MQLIncomeExpenditureSelectView()
    let tagView = MQLTagView()
    let sendView = MQLSendView()

    var totalValue = 0 {
        didSet {
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                guard let self else { return }
                totalLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                totalLabel.text = "\(totalValue)"
            }) { _ in
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.totalLabel.transform = .identity
                }
            }
            manager.transaction.money = totalValue
        }
    }
    var valueType: MQLIncomeExpenditureSelectView.SelectedType = .income {
        didSet {
            manager.transaction.type = valueType == .income ? .income : .expenditure
        }
    }

    let manager = MQLQuickLogManager()
    weak var delegate: NLNeedPresent?

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
            plus1.topAnchor.constraint(equalTo: titleInputView.bottomAnchor, constant: 12),
            plus1.leadingAnchor.constraint(equalTo: leadingAnchor),
            plus1.widthAnchor.constraint(equalToConstant: width),
            plus1.heightAnchor.constraint(equalToConstant: height)
        ])
        plus1.layer.shadowPath = UIBezierPath(rect: plus1.bounds).cgPath

        NSLayoutConstraint.activate([
            plus10.topAnchor.constraint(equalTo: plus1.topAnchor),
            plus10.leadingAnchor.constraint(equalTo: plus1.trailingAnchor, constant: space),
            plus10.widthAnchor.constraint(equalToConstant: width),
            plus10.heightAnchor.constraint(equalToConstant: height)
        ])
        plus10.layer.shadowPath = UIBezierPath(rect: plus10.bounds).cgPath

        NSLayoutConstraint.activate([
            plus100.topAnchor.constraint(equalTo: plus1.topAnchor),
            plus100.leadingAnchor.constraint(equalTo: plus10.trailingAnchor, constant: space),
            plus100.widthAnchor.constraint(equalToConstant: width),
            plus100.heightAnchor.constraint(equalToConstant: height)
        ])
        plus100.layer.shadowPath = UIBezierPath(rect: plus100.bounds).cgPath

        NSLayoutConstraint.activate([
            plus1000.topAnchor.constraint(equalTo: plus1.topAnchor),
            plus1000.leadingAnchor.constraint(equalTo: plus100.trailingAnchor, constant: space),
            plus1000.widthAnchor.constraint(equalToConstant: width),
            plus1000.heightAnchor.constraint(equalToConstant: height)
        ])
        plus1000.layer.shadowPath = UIBezierPath(rect: plus1000.bounds).cgPath
    }

    private func setup() {
        manager.vc = self

        titleInputView.delegate = manager

        setupButton(plusView: plus1)
        setupButton(plusView: plus10)
        setupButton(plusView: plus100)
        setupButton(plusView: plus1000)

        totalView.layer.cornerRadius = 15.0
        totalView.layer.borderWidth = 1.5
        totalView.layer.borderColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1).cgColor

        totalIcon.image = UIImage(named: "coin")
        totalIcon.contentMode = .scaleAspectFit

        totalLabel.text = "\(totalValue)"
        totalLabel.textColor = UIColor(red: 254 / 255, green: 204 / 255, blue: 90 / 255, alpha: 1)
        totalLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        totalLabel.keyboardType = .numberPad
        totalLabel.delegate = self

        incomeExpenditureSelectView.delegate = self

        tagView.layer.cornerRadius = 15.0
        tagView.layer.borderWidth = 1.5
        tagView.layer.borderColor = UIColor.lightGray.cgColor
        tagView.delegate = self

        sendView.delegate = manager
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
        addSubview(titleInputView)
        titleInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleInputView.topAnchor.constraint(equalTo: topAnchor),
            titleInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleInputView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(plus1)
        plus1.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plus10)
        plus10.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plus100)
        plus100.translatesAutoresizingMaskIntoConstraints = false
        addSubview(plus1000)
        plus1000.translatesAutoresizingMaskIntoConstraints = false

        addSubview(totalView)
        totalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalView.topAnchor.constraint(equalTo: plus1.bottomAnchor, constant: 18),
            totalView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -12)
        ])

        totalView.addSubview(totalIcon)
        totalIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalIcon.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 8),
            totalIcon.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 12),
            totalIcon.bottomAnchor.constraint(equalTo: totalView.bottomAnchor, constant: -8),
            totalIcon.heightAnchor.constraint(equalToConstant: 35),
            totalIcon.widthAnchor.constraint(equalToConstant: 35)
        ])

        totalView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: totalIcon.trailingAnchor, constant: 12),
            totalLabel.centerYAnchor.constraint(equalTo: totalIcon.centerYAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -12)
        ])

        addSubview(incomeExpenditureSelectView)
        incomeExpenditureSelectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            incomeExpenditureSelectView.topAnchor.constraint(equalTo: plus1.bottomAnchor, constant: 18),
            incomeExpenditureSelectView.leadingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: 12),
            incomeExpenditureSelectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            incomeExpenditureSelectView.heightAnchor.constraint(equalTo: totalView.heightAnchor)
        ])

        addSubview(tagView)
        tagView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: totalView.bottomAnchor, constant: 12),
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -12)
        ])

        addSubview(sendView)
        sendView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendView.topAnchor.constraint(equalTo: totalView.bottomAnchor, constant: 12),
            sendView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 12),
            sendView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            sendView.heightAnchor.constraint(equalTo: tagView.heightAnchor),
            sendView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension MQuickLogView {
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? MQLPlusButtonView else { return }
        totalLabel.resignFirstResponder()
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

// MARK: - MQLTagViewDelegate
extension MQuickLogView: MQLTagViewDelegate {
    func presentVC(_ vc: UIViewController) {
        delegate?.presentVC(vc)
    }

    func selectedTag(tag: TagData) {
        manager.transaction.tagId = tag._id
    }
}

// MARK: - UITextFieldDelegate
extension MQuickLogView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              let value = Int(text) else { return }
        totalValue = value
    }
}

// MARK: - MQLIncomeExpenditureSelectViewDelegate
extension MQuickLogView: MQLIncomeExpenditureSelectViewDelegate {
    func changeValueType(type: MQLIncomeExpenditureSelectView.SelectedType) {
        valueType = type
    }
}
