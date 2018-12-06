//
// Created by Igor Efremov on 01/08/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

class AmountHeaderView: UIView {
    static let defaultHeight: CGFloat = 60.0

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.awFont(ofSize: 36.0, type: .bold)
        lbl.textColor = UIColor.awYellow
        lbl.textAlignment = .center
        return lbl
    }()

    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.awFont(ofSize: 18.0, type: .regular)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        return iv
    }()

    var txType: TransactionType? {
        didSet {
            if let theTxType = txType {
                imageView.image = theTxType.image
                imageView.size = theTxType.image.size
                imageView.isHidden = false
            }
        }
    }

    convenience init(width: CGFloat, title: String?, color: UIColor = UIColor.mainColor, textColor: UIColor = UIColor.white) {
        self.init(frame: CGRect(origin: CGPoint.zero,
                size: CGSize(width: width,
                        height: 80)))
        titleLabel.text = title
        backgroundColor = color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    func applyLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(20)
        }

        infoLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(22)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }

        if let theImage = imageView.image {
            imageView.snp.makeConstraints { (make) in
                make.width.equalTo(theImage.size.width)
                make.height.equalTo(theImage.size.height)
                make.top.equalTo(infoLabel.snp.bottom).offset(-10)
                make.centerX.equalToSuperview()
            }
        }
    }

    func initControl() {
        backgroundColor = UIColor.mainColor
        addMultipleSubviews(with: [titleLabel, infoLabel, imageView])
    }
}
