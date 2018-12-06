//
// Created by Igor Efremov on 29/03/16.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import QuartzCore

class CAUnderlineLayer: CALayer {
    override init() {
        super.init()

        self.borderColor = UIColor.mainColor.cgColor
    }

    override init(layer: Any) {
        super.init(layer: layer)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UITextField {
    func useUnderline() {
        removeUnderlineLine()

        let border = CAUnderlineLayer()
        let borderWidth = CGFloat(1.0)
        border.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    func activeUnderlineLine() {
        removeUnderlineLine()

        let border = CAUnderlineLayer()
        let borderWidth = CGFloat(2.0)
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    fileprivate func removeUnderlineLine() {
        if let theSublayers = self.layer.sublayers {
            for l in theSublayers {
                if l is CAUnderlineLayer {
                    l.removeFromSuperlayer()
                    break
                }
            }
        }
    }
}
