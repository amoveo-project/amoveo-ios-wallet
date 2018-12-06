//
//  CommonView.swift
//
//
//  Created by Vladimir Malakhov on 02/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class CommonView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CommonView {
    
    func setup() {
        backgroundColor = .mainColor
    }
}
