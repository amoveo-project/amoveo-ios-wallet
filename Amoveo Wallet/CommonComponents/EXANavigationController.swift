//
// Created by Igor Efremov on 28/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class EXANavigationController: UINavigationController {
    convenience init(_ rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
