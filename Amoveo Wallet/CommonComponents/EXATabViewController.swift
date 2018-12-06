//
//  EXATabViewController.swift
//
//  Created by Igor Efremov on 06/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class EXATabViewController: UITabBarController {
    
    private let scrollingDelegate = ScrollingTabBarControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = scrollingDelegate
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
