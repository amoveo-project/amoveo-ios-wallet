//
// Created by Igor Efremov on 27/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import BetterSegmentedControl

extension BetterSegmentedControl: EXAUIStylesSupport {

    func applyStyles() {
        self.layer.cornerRadius = 4.0
        self.indicatorViewInset = 0.0
    }
}
