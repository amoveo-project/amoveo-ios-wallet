//
//  CreatePasswordViewLayer.swift
//
//  Created by Igor Efremov on 10/01/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SDCAlertView

typealias TextFieldValueHandler = (String) -> ()

enum CreatePasswordViewState {
    case loading, loaded
}

enum ValidationTextResult {
    case success, error
}

protocol CreatePasswordViewLayerProtocol {
    
    var onViewDidLoad: DefaultCallback? { get set }
    var onPassEditChanged: TextFieldValueHandler? { get set }
    var onVerifyEditChanged: TextFieldValueHandler? { get set }
    var onAskForCompare: ((String, String, Bool) -> ())? { get set }

    func setButtonEnable(_ status: Bool)
    func update(with validationResult: ValidationTextResult)
    func update(with loadState: CreatePasswordViewState)
    func updateIndicator(with strength: PasswordStrength)
    func showAlert()
}

final class CreatePasswordViewLayer: CommonViewLayer {
    
    var onViewDidLoad: DefaultCallback?
    var onPassEditChanged: TextFieldValueHandler?
    var onVerifyEditChanged: TextFieldValueHandler?
    var onAskForCompare: ((String, String, Bool) -> ())?
    
    private let createPasswordView = CreatePasswordView()
    private var topViewOffset: CGFloat = 0.0

    private var keyboardHeight: CGFloat = 0.0
    
    override func loadView() {
        super.loadView()
        view = createPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptForViewEvents()
        setDelegates()
        setHeaderTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)),
                name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topViewOffset = self.view.top
    }
    
    private func setHeaderTitle() {
        title = l10n(.walletPasswordTitle)
    }
}

extension CreatePasswordViewLayer: CreatePasswordViewLayerProtocol {
    
    func setButtonEnable(_ status: Bool) {
        createPasswordView.continueButton.isEnabled = status
    }
    
    func update(with validationResult: ValidationTextResult) {
        switch validationResult {
        case .success:
            createPasswordView.verifyPassTextField.textField.textColor = UIColor.valueLabelColor
        case .error:
            createPasswordView.verifyPassTextField.textField.textColor = UIColor.localRed
            onTapView()
        }
    }
    
    func update(with loadState: CreatePasswordViewState) {
        switch loadState {
        case .loading:
            createPasswordView.loadingView.startAnimating()
        case .loaded:
            createPasswordView.loadingView.stopAnimating()
        }
    }
    
    func updateIndicator(with strength: PasswordStrength) {
        createPasswordView.passwordIndicator.strength = strength
    }
    
    func showAlert() {
        EXADialogs.showMessage(l10n(.walletPasswordChanged), title: l10n(.walletPasswordVerify), buttonTitle: l10n(.commonOk),
                completionAction: {
                    [weak self] in
                    if let wSelf = self {
                        wSelf.navigationController?.popViewController(animated: true)
                    }
                })
    }
}

private extension CreatePasswordViewLayer {
    
    func subscriptForViewEvents() {
        subscriptForTextFieldsEdit()
        subscriptForTapActions()
    }
    
    func subscriptForTextFieldsEdit() {
        createPasswordView.onVerifyTextFieldEditChanged = { [weak self] text in
            self?.onVerifyEditChanged?(text)
        }
        createPasswordView.onPassTextFieldEditChanged = { [weak self] text in
            self?.onPassEditChanged?(text)
        }
    }
    
    func subscriptForTapActions() {
        createPasswordView.onContinueTapped = { [weak self] in
            self?.onTapContinue()
        }
        createPasswordView.onViewTapped = { [weak self] in
            self?.onTapView()
        }

        createPasswordView.onSkipTapped = { [weak self] in
            self?.onTapSkip()
        }
    }
    
    func setDelegates() {
        createPasswordView.passTextField.textField.delegate = self
        createPasswordView.verifyPassTextField.textField.delegate = self
    }
}

private extension CreatePasswordViewLayer {
    
    func onTapContinue() {
        guard let passText = createPasswordView.passTextField.textField.text,
            let verifyText = createPasswordView.verifyPassTextField.textField.text else {
            return
        }
        onAskForCompare?(passText, verifyText, false)
    }

    func onTapSkip() {
        let alert = AlertController(title: EXAAppInfoService.appTitle, message: l10n(.walletPasswordSkip), preferredStyle: .alert)
        alert.visualStyle = EXAInputDialogVisualStyle(alertStyle: .alert)
        let OKAction = AlertAction(title: l10n(.commonOk), style: .destructive, handler: { [weak self]
            (action) -> Void in
            AppState.sharedInstance.settings.skippedPass = true
            self?.onAskForCompare?("", "", true)
        })

        let cancelAction = AlertAction(title: l10n(.commonCancel), style: .preferred, handler: nil)

        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        alert.present()
    }
    
    func onTapView() {
        _ = createPasswordView.passTextField.resignFirstResponder()
        _ = createPasswordView.verifyPassTextField.resignFirstResponder()
        view.becomeFirstResponder()
    }
}

extension CreatePasswordViewLayer: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !DeviceType.isiPhone6OrMore {
            var newTopOffset: CGFloat = topViewOffset
            if createPasswordView.passTextField.isFirstResponder {
                newTopOffset -= 30
            }
            
            if createPasswordView.verifyPassTextField.isFirstResponder {
                newTopOffset -= 104
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.top = newTopOffset
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == createPasswordView.passTextField {
            _ = createPasswordView.passTextField.resignFirstResponder()
            createPasswordView.verifyPassTextField.becomeFirstResponder()
        }
        
        if textField == createPasswordView.verifyPassTextField {
            onTapContinue()
        }
        
        return true
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        (self.view as? CreatePasswordView)?.updateConstraintsWith(keyboardHeight: 0)
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
                if let userInfoValue: NSValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
                    let keyboardSize: CGSize = userInfoValue.cgRectValue.size
                    keyboardHeight = min(keyboardSize.height, keyboardSize.width)
                    (self.view as? CreatePasswordView)?.updateConstraintsWith(keyboardHeight: keyboardHeight)
                }
        }
    }
}
