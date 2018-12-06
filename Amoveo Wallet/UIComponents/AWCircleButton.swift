//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class AWCircleButton: EXACircleButton {
    private var imageArrowView: UIImageView = UIImageView(image: EXAGraphicsResources.btnArrow)

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor.awYellow
            } else {
                backgroundColor = UIColor.awYellowInactive
            }
        }
    }

    convenience init() {
        self.init(radius: 30.0)
        addSubview(imageArrowView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageArrowView.center = UIGeometryUtil.center(of: self.bounds)
    }
}
