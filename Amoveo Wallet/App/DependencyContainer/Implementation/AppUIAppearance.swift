//
//  AppUIAppearance.swift
//
//  Created by Igor Efremov on 30/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

final class AppUIAppearance: AppUIAppearanceProtocol {
    
    func setupUI() {
        setupNavigationBar()
        setupTabBar()
        setupSwitch()
    }
}

private extension AppUIAppearance {
    
    func setupNavigationBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.awYellow,
                                                            NSAttributedString.Key.font: UIFont.awFont(ofSize: 16.0, type: .medium)]
        UINavigationBar.appearance().tintColor = UIColor.awYellow
        UINavigationBar.appearance().barTintColor = UIColor.mainColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupTabBar() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().barTintColor = UIColor.tabbarColor
        UITabBar.appearance().tintColor = UIColor.mainColor
        UITabBar.appearance().isTranslucent = false
    }
    
    func setupSwitch() {
        UISwitch.appearance().onTintColor = UIColor.mainColor
    }
}


