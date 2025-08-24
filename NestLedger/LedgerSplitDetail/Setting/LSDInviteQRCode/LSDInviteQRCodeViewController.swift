// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/24.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

class LSDInviteQRCodeViewController: UIViewController {
    let ledgerSplitData: LedgerSplitData

    let imageView = UIImageView()
    let loadingView = UIActivityIndicatorView(style: .medium)

    init(ledgerSplitData: LedgerSplitData) {
        self.ledgerSplitData = ledgerSplitData
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
        navigationItem.title = "加入分帳本 QRCode"

        view.backgroundColor = .white

        loadingView.startAnimating()

        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        Task {
            let image = generateQRCode()
            await MainActor.run {
                loadingView.stopAnimating()
                loadingView.alpha = 0
                imageView.image = image
                imageView.alpha = 1
            }
        }
    }

    private func layout() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension LSDInviteQRCodeViewController {
    func generateQRCode() -> UIImage? {
        let uri = "https://nl.xxooooxx.org/ledger-split/invite?ledgerSplitId=\(ledgerSplitData._id)"
        let uriData = Data(uri.utf8)

        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(uriData, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 200 / outputImage.extent.size.width, y: 200 / outputImage.extent.size.height)
        let scaledImage = outputImage.transformed(by: transform)
        return UIImage(ciImage: scaledImage)
    }
}
