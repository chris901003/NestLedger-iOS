// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/3/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    static let cellId = "AvatarCollectionViewCellId"

    let imageView = UIImageView()

    var imageViewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(image: UIImage?) {
        imageView.image = image
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewHeightConstraint?.constant = bounds.width
        imageView.layer.cornerRadius = bounds.width / 2
    }

    private func setup() {
        imageView.backgroundColor = .blue.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    private func layout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 1)
        imageViewHeightConstraint?.isActive = true
    }
}
