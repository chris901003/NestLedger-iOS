// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/4.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "主頁", image: UIImage(systemName: "list.clipboard"), selectedImage: nil)

        let accountViewController = AccountViewController()
        accountViewController.tabBarItem = UITabBarItem(title: "帳號", image: UIImage(systemName: "person.crop.circle"), selectedImage: nil)

        viewControllers = [mainViewController, accountViewController]

        selectedIndex = 0
    }
}
