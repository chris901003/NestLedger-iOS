// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/8/25.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import CoreImage

class QRCodeGenerator {
    static func generateQRCode(str: String) -> UIImage? {
        let strData = Data(str.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(strData, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        guard let outputImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 200 / outputImage.extent.size.width, y: 200 / outputImage.extent.size.height)
        let scaledImage = outputImage.transformed(by: transform)
        return UIImage(ciImage: scaledImage)
    }
}
