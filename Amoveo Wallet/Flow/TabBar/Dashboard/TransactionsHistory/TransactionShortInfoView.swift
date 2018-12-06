//
// Created by Igor Efremov on 27/06/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class TransactionShortInfoView: UIView {
    private let imageView: UIImageView = UIImageView(image: nil)
    private var addressLabel = UILabel("")
    private let dateLabel = UILabel("DATE")
    private let sideImageWidth = EXAGraphicsResources.transactionType(.sent).size.width
    private var directionTypeLabel = UILabel("DIRECTION")
    private var amountLabel: AmountTransactionLabel?
    private var infoLabel: AWLabel = AWLabel("", textColor: UIColor.mainColor, font: UIFont.systemFont(ofSize: 12.0))

    convenience init(transaction: Transaction) {
        self.init(frame: CGRect.zero)

        self.backgroundColor = UIColor.clear
        self.size = CGSize(width: 250, height: 50)

        imageView.image = EXAGraphicsResources.transactionType(transaction.type)
        imageView.size = imageView.image!.size

        addressLabel.font = UIFont.awFont(ofSize: 12.0, type: .regular)
        addressLabel.textColor = UIColor.mainColor
        addressLabel.textAlignment = .left

        dateLabel.font = UIFont.awFont(ofSize: 11.0, type: .regular)
        dateLabel.textColor = UIColor.grayTitleColor
        dateLabel.textAlignment = .left

        infoLabel.textAlignment = .right

        let amountString: String = EXAWalletFormatter.formattedAmount(transaction.amountString) ?? "?"
        amountLabel = AmountTransactionLabel(amountString, ticker: transaction.ticker)
        for v in [imageView, addressLabel, directionTypeLabel, amountLabel!, dateLabel, infoLabel] as [UIView] {
            addSubview(v)
        }

        addressLabel.text = transaction.destination
        addressLabel.sizeToText()

        directionTypeLabel.font = UIFont.awFont(ofSize: 16.0, type: .medium)
        directionTypeLabel.text = transaction.type.description
        directionTypeLabel.textAlignment = .left
        directionTypeLabel.sizeToText()

        dateLabel.text = transaction.date
        dateLabel.sizeToText()

        infoLabel.text = ""
        infoLabel.textColor = UIColor.mainColor

        if transaction.pending {
            self.alpha = 0.35
            infoLabel.text = "Pending"
        }
        
        infoLabel.sizeToText()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        let sideOffset: CGFloat = 0
        let rc = self.bounds

        imageView.origin = CGPoint(x: sideOffset, y: self.center.y - imageView.size.height / 2)
        if let theAmountLabel = amountLabel {
            theAmountLabel.origin = CGPoint(x: rc.width - 20 - theAmountLabel.width, y: imageView.top)
            addressLabel.origin = CGPoint(x: imageView.right + 20, y: ceil(imageView.center.y - addressLabel.size.height / 2))
            directionTypeLabel.origin = CGPoint(x: imageView.right + 20, y: theAmountLabel.origin.y)
        } else {
            directionTypeLabel.origin = CGPoint(x: imageView.right + 20, y: self.center.y - directionTypeLabel.height/2)
        }
        dateLabel.origin = CGPoint(x: /*rc.width - 20 - dateLabel.width*/imageView.right + 20, y: 35)
        dateLabel.bottom = imageView.bottom

        infoLabel.origin = CGPoint(x: rc.width - 20 - infoLabel.width, y: self.center.y - directionTypeLabel.height/2)
        infoLabel.bottom = imageView.bottom
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

