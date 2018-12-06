//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class OnboardingAWPresenter: UIViewController {

    var onHide: DefaultCallback?

    override func viewDidLoad() {
        super.viewDidLoad()

        onHide?()
    }
}
