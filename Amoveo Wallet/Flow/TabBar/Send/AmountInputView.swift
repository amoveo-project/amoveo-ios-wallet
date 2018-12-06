//
// Created by Igor Efremov on 12/07/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

protocol AmountInputViewActionDelegate: class {
    func onAmountDidChange()
    func sendAll()
}

class AmountInputView: UIView {
    private let amountStaticLabel: UILabel = {
        let lbl = UILabel(CryptoTicker.VEO.description)
        lbl.font = UIFont.awFont(ofSize: 24.0, type: .regular)
        lbl.textColor = UIColor.white
        return lbl
    }()
    private let availableBalanceLabel: UILabel = {
        let lbl = UILabel("")
        lbl.font = UIFont.awFont(ofSize: 14.0, type: .regular)
        lbl.textColor = UIColor.awGray
        return lbl
    }()
    private let sendAllLabel: UILabel = {
        let lbl = UILabel("Send all")
        lbl.font = UIFont.awFont(ofSize: 14.0, type: .regular)
        lbl.textColor = UIColor.awYellow
        lbl.textAlignment = .right
        return lbl
    }()

    private let amountValueField: UITextField = UITextField()

    weak var actionDelegate: AmountInputViewActionDelegate?
    var incorrect: Bool = false {
        didSet {
            amountValueField.textColor = incorrect ? .localRed : .titleLabelColor
        }
    }

    var availableAmount: AmountValue? {
        didSet {
            availableBalanceLabel.text = availableAmount?.toVEOString() ?? ""
        }
    }

    var amountValue: String {
        return amountValueField.text ?? ""
    }

    convenience init() {
        self.init(frame: CGRect.zero)
        initControl()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setupAmount(_ amountValue: AmountValue) {
        amountValueField.text = amountValue.toVEOString()
    }

    func applyStyles() {
        amountValueField.keyboardAppearance = .dark
        amountValueField.attributedPlaceholder = NSAttributedString(string: "0.00",
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.exaPlaceholderColor,
                             NSAttributedString.Key.font: UIFont.awFont(ofSize: 48.0, type: .bold)])
        amountValueField.textColor = UIColor.titleLabelColor
        amountValueField.tintColor = UIColor.titleLabelColor
        amountValueField.autocorrectionType = .no
        amountValueField.keyboardType = .decimalPad
        amountValueField.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)

        amountValueField.font = UIFont.awFont(ofSize: 48.0, type: .bold)
    }

    func applyLayout() {
        let sideOffset: CGFloat = 20
        let topOffset: CGFloat = 20

        amountStaticLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(20)
            make.left.top.equalToSuperview().offset(topOffset)
        }

        availableBalanceLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(16)
            make.left.equalToSuperview().offset(topOffset)
            make.top.equalTo(amountStaticLabel.snp.bottom).offset(1)
        }

        sendAllLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(16)
            make.right.equalToSuperview().offset(-sideOffset)
            make.top.equalTo(availableBalanceLabel.snp.top)
        }

        amountValueField.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(availableBalanceLabel.snp.bottom).offset(topOffset)
            make.height.equalTo(36)
        }
    }

    @objc func tfDidChange() {
        incorrect = false

        if EXACommon.dotLocale.count == 1 {
            let delimiter = Character(EXACommon.dotLocale)
            amountValueField.text = amountValue.replaceDotWithLocalDelimiter()

            let delimiterCount = amountValue.filter { $0 == delimiter }.count
            if amountValue.hasPrefix("0") && delimiterCount == 0 && amountValue.count > 1 {
                var currentText = amountValueField.text
                if currentText != nil {
                    currentText!.insert(delimiter, at: currentText!.index(after: currentText!.startIndex))
                    amountValueField.text = currentText
                }
            }

            if delimiterCount > 1 {
                if let index = amountValue.lastIndex(of: delimiter) {
                    var currentText = amountValueField.text
                    if currentText != nil {
                        currentText!.remove(at: index)
                        amountValueField.text = currentText
                    }
                }
            }
        }

        actionDelegate?.onAmountDidChange()
    }

    @objc func onSendAll() {
        actionDelegate?.sendAll()
    }

    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return amountValueField.resignFirstResponder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }

    func initControl() {
        addMultipleSubviews(with: [amountStaticLabel, availableBalanceLabel, sendAllLabel, amountValueField])

        sendAllLabel.addTapTouch(self, action: #selector(onSendAll))
    }
}
