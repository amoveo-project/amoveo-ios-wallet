//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class EXACircleButton: UIButton {
    private var _radius: CGFloat = 0.0
    private var _color: UIColor = UIColor.awYellow

    var radius: CGFloat {
        return _radius
    }

    convenience init(radius: CGFloat, color: UIColor = UIColor.awYellow) {
        self.init(frame: CGRect.zero)
        _radius = radius
        _color = color
        size = CGSize(width: radius * 2, height: radius * 2)
        initControl()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    fileprivate func initControl() {
        layer.cornerRadius = _radius
        backgroundColor = _color
    }
}
