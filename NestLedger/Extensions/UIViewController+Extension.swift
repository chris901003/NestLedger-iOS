// Created for NestLedger in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/5/8.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension UIViewController {
    func addTapBackgroundDismissKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension UIViewController {
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
