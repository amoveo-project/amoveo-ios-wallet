//
//  EmptyHistoryTransactionView.swift
//
//
//  Created by Igor Efremov on 05/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class EmptyHistoryTransactionView: UIView {
    private var hourglassImageView: UIImageView = UIImageView(image: UIImage(named: "hourglass.png"))
    private var havenotTransactionStaticLabel: UILabel = UILabel("You have no transactions")
    private var helpStaticLabel: UILabel = UILabel("Your future transactions\nwill be shown here")
    
    weak var actionDelegate: EXAHistoryViewActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }
    
    func initControl() {
        addSubview(hourglassImageView)
        addSubview(havenotTransactionStaticLabel)
        addSubview(helpStaticLabel)
        
        havenotTransactionStaticLabel.font = UIFont.systemFont(ofSize: 20.0)
        havenotTransactionStaticLabel.textColor = UIColor.valueLabelColor
        havenotTransactionStaticLabel.textAlignment = .center
        
        helpStaticLabel.font = UIFont.systemFont(ofSize: 16.0)
        helpStaticLabel.textColor = UIColor.rgba(0x0000008a)
        helpStaticLabel.numberOfLines = 2
        helpStaticLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        havenotTransactionStaticLabel.width = self.width
        havenotTransactionStaticLabel.origin = CGPoint(x: 0, y: UIGeometryUtil.center(of: self.bounds).y)
        
        hourglassImageView.size = UIImage(named: "hourglass.png")!.size
        hourglassImageView.left = UIGeometryUtil.center(of: self.bounds).x - hourglassImageView.width / 2
        hourglassImageView.bottom = havenotTransactionStaticLabel.top - 22
        
        helpStaticLabel.width = self.width
        helpStaticLabel.origin = CGPoint(x: 0, y: havenotTransactionStaticLabel.bottom + 22)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }
}
