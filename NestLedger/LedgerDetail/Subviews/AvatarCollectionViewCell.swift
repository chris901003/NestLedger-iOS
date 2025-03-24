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
        imageView.layer.cornerRadius = bounds.width / 2
    }

    private func setup() {
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    private func layout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
    }
}
