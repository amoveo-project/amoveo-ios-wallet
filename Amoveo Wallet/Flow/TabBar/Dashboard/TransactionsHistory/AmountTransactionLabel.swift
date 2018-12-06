//
// Created by Igor Efremov on 12/09/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class AmountTransactionLabel: UIView {
    private var valueLabel: UILabel = UILabel("")

    convenience init(_ amount: String, ticker: CryptoTicker) {
        self.init(frame: CGRect.zero)

        valueLabel.font = UIFont.awFont(ofSize: 16.0, type: .medium)
        valueLabel.textAlignment = .left
        valueLabel.textColor = UIColor.invertedTitleLabelColor
        valueLabel.text = "\(amount) \(ticker.description)"
        valueLabel.sizeToText()

        self.size = CGSize(width: valueLabel.width, height: 18)
        addSubview(valueLabel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        valueLabel.origin = CGPoint.zero
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
