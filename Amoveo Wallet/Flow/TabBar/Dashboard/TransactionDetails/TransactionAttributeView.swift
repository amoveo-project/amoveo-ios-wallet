//
// Created by Igor Efremov on 01/08/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class TransactionAttributeView: UIView {
    private let imageView: UIImageView = UIImageView(image: nil)
    private let sideImageWidth = EXAGraphicsResources.transactionType(.sent).size.width

    private var viewBtn: EXAButton? = nil
    private var _attribute: TransactionAttribute?

    weak var actionDelegate: TransactionDetailsActionDelegate?

    private let titleLabel: UILabel = {
        let lb = UILabel("", textColor: UIColor.grayTitleColor, font: UIFont.awFont(ofSize: 13.0, type: .regular))
        lb.textAlignment = .left
        return lb
    }()

    private let valueLabel: UILabel = {
        let lb = UILabel("", textColor: UIColor.invertedTitleLabelColor, font: UIFont.awFont(ofSize: 16.0, type: .bold))
        lb.lineBreakMode = .byCharWrapping
        lb.numberOfLines = 3
        lb.textAlignment = .right
        lb.height = 48
        return lb
    }()

    convenience init(attributeList: TransactionAttributesList, attribute: TransactionAttribute) {
        self.init(frame: CGRect.zero)

        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

        _attribute = attribute

        if attribute.type == .action {
            viewBtn = EXAButton(with: attribute.description, color: UIColor.mainColor)
            viewBtn?.style = .hollow
            viewBtn?.addTarget(self, action: #selector(onTapViewInBlockchain), for: .touchUpInside)
        } else {
            titleLabel.text = attribute.description
            valueLabel.text = attributeList.txAttribute(by: attribute)
            valueLabel.textColor = UIColor.invertedTitleLabelColor
            if attribute == .txHash || attribute == .to || attribute == .from {
                imageView.image = EXAGraphicsResources.copySmall
                imageView.size = EXAGraphicsResources.copySmall.size
                imageView.addTapTouch(self, action: #selector(onCopyToClipboardTap))
                self.addTapTouch(self, action: #selector(onCopyToClipboardTap))

                valueLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
                valueLabel.textAlignment = .left
            }
        }

        [titleLabel, valueLabel, imageView, viewBtn].compactMap{$0}.forEach{addSubview($0)}
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        guard let theAttribute = _attribute else { return }

        let sideOffset: CGFloat = 20
        let rc = self.bounds

        titleLabel.width = rc.width
        titleLabel.height = 20
        titleLabel.top = sideOffset
        titleLabel.left = sideOffset

        if theAttribute == .txHash || theAttribute == .to || theAttribute == .from {
            imageView.top = 50
            imageView.right = sideOffset

            valueLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            valueLabel.textAlignment = .left

            valueLabel.width = rc.width - 100
            valueLabel.height = 48
            valueLabel.top = 50
            valueLabel.left = sideOffset
        } else {
            valueLabel.width = rc.width
            valueLabel.height = sideOffset
            valueLabel.top = sideOffset
            valueLabel.right = sideOffset
        }

        viewBtn?.width = rc.width - 160
        viewBtn?.height = EXAButton.defaultHeight
        viewBtn?.center = self.center
    }

    @objc func onTapViewInBlockchain() {
        actionDelegate?.showCurrentTxInBlockchain()
    }

    @objc func onCopyToClipboardTap() {
        actionDelegate?.copyToClipboard(valueLabel.text)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
