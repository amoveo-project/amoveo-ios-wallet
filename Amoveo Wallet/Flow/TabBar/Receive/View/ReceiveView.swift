//
//  ReceiveView.swift
//
//  Created by Igor Efremov on 09/08/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

enum CopyOption {
    case manual
    case qr
}
typealias CopyOptionHandler = ((CopyOption) -> ())

final class ReceiveView: CommonView {
    
    var onCopy: CopyOptionHandler?
    var onShare: DefaultCallback?

    private let bottomView = ContainerBottomView()
    
    let recipientAddressValue: UILabel = {
        let lbl = UILabel()
        let fontSize: CGFloat = DeviceType.isLongWidthScreen ? 16.0 : 12.0
        lbl.font = UIFont.awFont(ofSize: fontSize, type: .medium)
        lbl.textColor = UIColor.mainColor
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byCharWrapping
        return lbl
    }()
    
    let copyImageView: UIImageView = {
        let img = UIImageView(image: EXAGraphicsResources.copy)
        img.contentMode = .center
        return img
    }()
    
    let shareImageView: UIImageView = {
        let img = UIImageView(image: EXAGraphicsResources.share)
        img.contentMode = .center
        return img
    }()

    let containerRecipientQRCodeImageView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 10
        return v
    }()
    
    let recipientQRCodeImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let loader: EXACircleStrokeLoadingIndicator = {
        let loader = EXACircleStrokeLoadingIndicator()
        loader.isHidden = true
        return loader
    }()
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ReceiveView {
    
    func setupView() {
        addSubviews()
        applyLayout()
        addEvents()
    }
    
    func addSubviews() {
        let allSubviews = [bottomView, containerRecipientQRCodeImageView, recipientQRCodeImageView, loader]

        bottomView.addMultipleSubviews(with: [copyImageView, shareImageView, recipientAddressValue])
        addMultipleSubviews(with: allSubviews)
    }
    
    func applyLayout() {
        let topOffset: CGFloat = 20
        let iconSize: CGFloat = 60
       
        bottomView.snp.makeConstraints { (make) in
            make.width.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.height.equalTo(209)
        }

        containerRecipientQRCodeImageView.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().inset(68)
            make.height.equalTo(containerRecipientQRCodeImageView.snp.width)
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview()
        }

        recipientQRCodeImageView.snp.makeConstraints{ (make) in
            make.width.height.equalTo(containerRecipientQRCodeImageView.snp.width).inset(20)
            make.center.equalTo(containerRecipientQRCodeImageView.snp.center)
        }
        
        recipientAddressValue.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(76)
        }

        shareImageView.snp.makeConstraints{ (make) in
            make.width.height.equalTo(iconSize)
            make.centerX.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-30)
        }
    
        copyImageView.snp.makeConstraints{ (make) in
            make.width.height.equalTo(iconSize)
            make.left.equalTo(shareImageView.snp.right).offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        loader.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
}

private extension ReceiveView {
    
    func addEvents() {
        copyImageView.addTapTouch(self, action: #selector(onCopyToClipboardTapAddressManual))
        recipientQRCodeImageView.addTapTouch(self, action: #selector(onCopyToClipboardTapAddressQR))
        recipientAddressValue.addTapTouch(self, action: #selector(onCopyToClipboardTapAddressManual))
        shareImageView.addTapTouch(self, action: #selector(onTapRequestPayment))
    }
    
    @objc func onCopyToClipboardTapAddressQR() {
        onCopy?(.qr)
    }
    
    @objc func onCopyToClipboardTapAddressManual() {
        onCopy?(.manual)
    }
    
    @objc func onTapRequestPayment() {
        onShare?()
    }
}

