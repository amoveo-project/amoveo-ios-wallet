//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import QuartzCore

class ContainerBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    func initControl() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10.0
    }
}
