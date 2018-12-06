//
//  PasswordStrengthIndicator.swift
//
//  Created by Igor Efremov on 21/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import QuartzCore

enum PasswordStrength: Int {
    case empty, weak, med, strong
}

class PasswordStrengthIndicator: UIView {
    var lineFilledView: UIView = UIView(frame: CGRect.zero)
    var strength: PasswordStrength = .empty {
        didSet {
            let rc = self.bounds
            var toColor: UIColor = UIColor.clear
            var toWidth: CGFloat = 0.0
            toColor = UIColor.white
            
            switch strength {
                case .weak:
                    toWidth = rc.size.width / 3
                case .med:
                    toWidth = 2 * rc.size.width / 3
                case .strong:
                    toWidth = rc.size.width
                default:
                    noop()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lineFilledView.backgroundColor = toColor
                self.lineFilledView.width = toWidth
                self.lineFilledView.origin = CGPoint.zero
            })
        }
    }
    
    var indicatorHeight: CGFloat {
        get {
            return 4.0
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        initControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }
    
    func initControl() {
        lineFilledView.height = 4
        lineFilledView.backgroundColor = UIColor.red
        addSubview(lineFilledView)
        backgroundColor = UIColor.clear
    }
}
