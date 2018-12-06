//
// Created by Igor Efremov on 12/07/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

protocol RecipientViewActionDelegate: class {
    func scanQR()
    func onAddressChanged()
}

class RecipientView: UIView {
    private var _addressValue: String = ""
    
    private let recipientAddressStaticLabel: UILabel = UILabel("To")
    private let addressValueField: UITextField = UITextField()
    private let scanQRImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "qr"))

    weak var actionDelegate: RecipientViewActionDelegate?

    var incorrect: Bool = false {
        didSet {
            addressValueField.textColor = incorrect ? .localRed : .titleLabelColor
        }
    }

    var addressValue: String {
        get {
            //return _addressValue
            return addressValueField.text!
        }

        set {
            _addressValue = newValue
            addressValueField.text = _addressValue
            tfDidChange()
        }
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        initControl()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func applyStyles() {
        recipientAddressStaticLabel.textColor = UIColor.grayTitleColor

        addressValueField.keyboardAppearance = .dark
        addressValueField.attributedPlaceholder = NSAttributedString(string: "Paste recipient address or scan QR code",
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.exaPlaceholderColor])
        addressValueField.textColor = UIColor.titleLabelColor
        addressValueField.tintColor = UIColor.titleLabelColor
        addressValueField.autocorrectionType = .no
        addressValueField.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
    }

    func applyLayout() {
        let topOffset: CGFloat = 20

        recipientAddressStaticLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.left.top.equalToSuperview().offset(topOffset)
        }

        addressValueField.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(recipientAddressStaticLabel.snp.bottom).offset(10)
            make.height.equalTo(52)
        }

        scanQRImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    func initControl() {
        self.addSubview(recipientAddressStaticLabel)
        self.addSubview(addressValueField)
        self.addSubview(scanQRImageView)

        scanQRImageView.addTapTouch(self, action: #selector(onTapScan))
    }

    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return addressValueField.resignFirstResponder()
    }

    @objc func onTapScan() {
        actionDelegate?.scanQR()
    }

    @objc func tfDidChange() {
        incorrect = false
        actionDelegate?.onAddressChanged()
    }
}

