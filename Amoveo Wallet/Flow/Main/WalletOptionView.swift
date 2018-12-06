//
//  WalletOptionView.swift
//
//  Created by Igor Efremov on 05/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

final class WalletOptionView: UIView {
    
    var onTapped: DefaultCallback?

    private var _type: WalletOptionViewType = .create
    
    private let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.textColor = UIColor.mainColor
        title.font = UIFont.awFont(ofSize: 20, type: .bold)
        return title
    }()
    
    init(_ type: WalletOptionViewType) {
        super.init(frame: .zero)
        setup(with: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WalletOptionView {
    
    func setup(with type: WalletOptionViewType) {
        setAttributes(for: type)
        addSubviews()
        applyLayout()
        applyStyle()
        addTapAction()
    }
    
    func setAttributes(for type: WalletOptionViewType) {
        if type == .create {
            backgroundColor = UIColor.awYellow
        } else {
            backgroundColor = UIColor.white
        }

        icon.image = type.icon
        title.text = type.title
    }
    
    func addSubviews() {
        let subviews = [icon, title]
        addMultipleSubviews(with: subviews)
    }
    
    func applyLayout() {
        let sz: CGSize

        if _type == .create {
            sz = EXAGraphicsResources.create.size
        } else {
            sz = EXAGraphicsResources.restore.size
        }

        let iconWidth = sz.width
        let iconHeight = sz.height

        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
        }
        title.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(22)
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func applyStyle() {
        layer.cornerRadius = 10.0
    }
    
    func addTapAction() {
        addTapTouch(self, action: #selector(tapAction))
    }
    
    @objc func tapAction() {
        onTapped?()
    }
}
