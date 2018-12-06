//
//  HidingSreenView.swift
//
//
//  Created by Vladimir Malakhov on 20/06/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

final class HidingScreenView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HidingScreenView {
    
    func setup() {
        setupLogo()
        setupStyle()
    }
    
    func setupLogo() {

        let logo = #imageLiteral(resourceName: "logo_launch.png")
        let imageView = UIImageView(image: logo)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(160)
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func setupStyle() {
        backgroundColor = UIColor.rgb(0x345972)
    }
}
