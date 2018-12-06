//
//  CreatePasswordView.swift
//
//  Created by Igor Efremov on 06/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

final class CreatePasswordView: CommonView {
    static let minPassSymbols = 8
    
    var onPassTextFieldEditChanged: TextFieldValueHandler?
    var onVerifyTextFieldEditChanged: TextFieldValueHandler?
    var onViewTapped: DefaultCallback?
    var onContinueTapped: DefaultCallback?
    var onSkipTapped: DefaultCallback?

    private let bottomView = ContainerBottomView()

    private var keyboardHeight: CGFloat = 0.0
    
    let explanationLabel: AWLabel = {
        let lbl = AWLabel(l10n(.walletPasswordExplanation))
        lbl.style = .main
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    let passTextField: EXAHeaderTextFieldView = {
        let minPassSymbolsString = "\(minPassSymbols)"
        let tf = EXAHeaderTextFieldView("Enter password", style: .pass, header: String(format: l10n(.setupPassEnterPass), minPassSymbolsString))
        tf.textField.keyboardType = .asciiCapable
        tf.isSecure = true
        return tf
    }()

    let verifyPassTextField: EXAHeaderTextFieldView = {
        let tf = EXAHeaderTextFieldView("Enter password again", style: .verify, header: l10n(.walletPasswordVerify))
        tf.textField.keyboardType = .asciiCapable
        tf.isSecure = true
        return tf
    }()
    
    let continueButton: AWCircleButton = {
        let btn = AWCircleButton()
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(onButtonTapAction), for: .touchUpInside)
        return btn
    }()

    let skipButton: EXAButton = {
        let btn = EXAButton(with: "SKIP")
        btn.addTarget(self, action: #selector(onTapSkip), for: .touchUpInside)
        return btn
    }()
    
    let loadingView: EXACircleStrokeLoadingIndicator = {
        let load = EXACircleStrokeLoadingIndicator()
        load.isHidden = true
        return load
    }()
    
    let passwordIndicator: PasswordStrengthIndicator = {
        let password = PasswordStrengthIndicator()
        return password
    }()
        
    override init() {
        super.init()
        setup()
        subscriptForViewEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func subscriptForViewEvents() {
        passTextField.textField.onEditChanged = { [weak self] text in
            self?.onPassTextFieldEditChanged?(text)
        }
        verifyPassTextField.textField.onEditChanged = { [weak self] text in
            self?.onVerifyTextFieldEditChanged?(text)
        }
    }

    func updateConstraintsWith(keyboardHeight: CGFloat) {
        self.keyboardHeight = keyboardHeight
        updateConstraints()
    }

    override func updateConstraints() {
        bottomView.snp.updateConstraints { (make) in
            make.width.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(10.0 - keyboardHeight)
            make.height.equalTo(189)
        }

        super.updateConstraints()
    }
}

private extension CreatePasswordView {
    
    func setup() {
        addSubviews()
        applyStyles()
        applyLayout()
        applyDefaultValues()
        addTap()
    }


    func applyDefaultValues() {
#if TEST
        passTextField.textField.text = "12345678"
        verifyPassTextField.textField.text = "12345678"
        continueButton.isEnabled = true
#endif
    }
    
    func addSubviews() {
        let allSubviews = [skipButton, bottomView, passTextField, passwordIndicator, verifyPassTextField]
        bottomView.addMultipleSubviews(with: [explanationLabel, continueButton])
        addMultipleSubviews(with: allSubviews)
    }

    func applyStyles() {

        passTextField.applyStyles()
        verifyPassTextField.applyStyles()
    }
    
    func applyLayout() {
        
        let sideOffset: CGFloat = 30
        let topOffset: CGFloat = 30

        skipButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(bottomView.snp.top).offset(10)
            make.width.equalTo(90)
            make.height.equalTo(44)
        }

        bottomView.snp.makeConstraints { (make) in
            make.width.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.height.equalTo(189)
        }

        explanationLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(30)
            make.width.equalToSuperview().offset(-150)
            make.height.equalToSuperview().offset(-60)
        }
        
        passTextField.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(passTextField.defaultHeight)
            make.top.equalToSuperview().offset(topOffset)
            make.centerX.equalToSuperview()
        }
        
        passwordIndicator.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(passwordIndicator.indicatorHeight)
            make.top.equalTo(passTextField.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        verifyPassTextField.snp.makeConstraints{ (make) -> Void in
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(verifyPassTextField.defaultHeight)
            make.top.equalTo(passTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(continueButton.size.width)
            make.height.equalTo(continueButton.size.height)
            make.bottom.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(-30)
        }

        passTextField.applyLayout()
        verifyPassTextField.applyLayout()
        
        /*loadingView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(self)
        }*/
    }
    
    func addTap() {
        addTapTouch(self, action: #selector(onViewTapAction))
    }
    
    @objc func onViewTapAction() {
        onViewTapped?()
    }
    
    @objc func onButtonTapAction() {
        onContinueTapped?()
    }

    @objc func onTapSkip() {
        onSkipTapped?()
    }
}
