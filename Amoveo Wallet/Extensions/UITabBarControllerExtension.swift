//
//  UITabBarController+Extension.swift
//
//  Created by Vladimir Malakhov on 05/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func add(_ viewLayers: [ViewLayer]) {
        viewControllers = viewLayers
    }
}


