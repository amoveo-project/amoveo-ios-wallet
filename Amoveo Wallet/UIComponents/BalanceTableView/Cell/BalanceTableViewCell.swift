//
//  BalanceTableViewCell.swift
//
//
//  Created by Vladimir Malakhov on 19/04/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

private enum BalanceCellAppereance {
    
    case title
    case amount
    
    var font: UIFont {
        switch self {
        case .amount:
            return UIFont.systemFont(ofSize: 24.0,
                                     weight: .medium)
        case .title:
            return UIFont.systemFont(ofSize: 12.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .amount:
            return UIColor.valueLabelColor
        case .title:
            return UIColor.titleLabelColor
        }
    }
}

private struct ConstansSize {
    
    static let imageSide = 39.0
    static let labelHeight = 12.0
    static let commonOffset = 16.0
}

private typealias Appereance = BalanceCellAppereance
private typealias C = ConstansSize

final class BalanceTableViewCell: UITableViewCell {
    
    override var reuseIdentifier: String {
        get {
            return "BalanceTableViewCellIdentifier"
        }
    }
    
    private let logo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = image.size.width / 2
        return image
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Appereance.title.font
        lbl.textColor = Appereance.title.textColor
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let amountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Appereance.amount.font
        lbl.textColor = Appereance.amount.textColor
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let cellSubviews = [logo, titleLabel, amountLabel]
        contentView.addMultipleSubviews(with: cellSubviews)
        
        logo.snp.makeConstraints { (make) in
            make.width.equalTo(C.imageSide)
            make.height.equalTo(C.imageSide)
            make.top.equalToSuperview().offset(C.commonOffset)
            make.left.equalToSuperview().offset(C.commonOffset)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(C.commonOffset)
            make.height.equalTo(C.labelHeight)
            make.left.equalTo(logo.snp.right).offset(C.commonOffset)
            make.top.equalToSuperview().offset(C.commonOffset)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(C.commonOffset)
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(logo.snp.right).offset(C.commonOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BalanceTableViewCell {

    func update(with balance: Balance) {
        setData(balance)
    }
}

private extension BalanceTableViewCell {
    
    func setData(_ balance: Balance) {
        logo.image = balance.type.image
        titleLabel.text = balance.type.title
        amountLabel.text = String(balance.value ?? AmountValue.constantZero())
    }
}

private extension BalanceTableViewCell {
    
    func setCellVisible(value: CGFloat) {
        logo.alpha = value
        titleLabel.alpha = value
        amountLabel.alpha = value
    }
}
