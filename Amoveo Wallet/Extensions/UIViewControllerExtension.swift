//
//  UIViewControllerExtension.swift
//
//
//  Created by Igor Efremov on 21/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupBackButton() {
        let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = customBackButton
    }

    func addTabBar(with type: AppTabFrameType) {
        let tab = UITabBarItem(title: type.title, image: type.icon, tag: type.hashValue)
        tabBarItem = tab
    }

    func wrapWithNavigation() -> UINavigationController {
        let navigation = EXANavigationController()
        navigation.addChild(self)
        return navigation
    }
}
