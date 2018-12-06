//
//  RootViewController.swift
//  Amoveo Wallet
//
//  Created by Igor Efremov on 11/03/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.mainColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

