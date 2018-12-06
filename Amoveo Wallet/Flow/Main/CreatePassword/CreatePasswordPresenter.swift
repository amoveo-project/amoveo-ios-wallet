//
//  CreatePasswordPresenter.swift
//
//  Created by Igor Efremov on 06/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class CreatePasswordParams {
    var account: Account?
    var isPasswordChange = false
    var isRestored = false
}

protocol CreatePasswordPresenterProtocol {
    func start(with params: CreatePasswordParams)
}

final class CreatePasswordPresenter {
    
    var viewLayer: CreatePasswordViewLayerProtocol?
    
    private var params: CreatePasswordParams?
    private let walletManager = WalletManager()
    private let wallets = AppState.sharedInstance.walletsManager
    
    private let validator = Validator()
    private let minPassSymbols = 8
    
    private var password: String?
}

extension CreatePasswordPresenter: CreatePasswordPresenterProtocol {
    
    func start(with params: CreatePasswordParams) {
        self.params = params
        subscriptForViewEvents()
    }
    
    func subscriptForViewEvents() {
        viewLayer?.onPassEditChanged = passEdit
        viewLayer?.onVerifyEditChanged = verifyEdit
        viewLayer?.onAskForCompare = compare
    }
}

private extension CreatePasswordPresenter {

    func passEdit(_ text: String) {
        validate(text: text, type: .pass)
        strength(text: text, type: .pass)
    }
    
    func verifyEdit(_ text: String) {
        validate(text: text, type: .verify)
        strength(text: text, type: .verify)
        viewLayer?.update(with: .success)
    }
    
    func compare(_ passText: String, _ verifyText: String, skip: Bool = false) {
        if !skip {
            guard passText.count >= minPassSymbols, verifyText.count >= minPassSymbols,
                  passText.elementsEqual(verifyText) else {
                viewLayer?.update(with: .error)
                return
            }
        }

        save(passText)
        createWallet()
    }
}

private extension CreatePasswordPresenter {
    
    func validate(text: String, type: UnderlineTextFieldStyle) {
        let result = validator.validate(text)
        switch result {
        case .ok:
            if type == .verify {
                let status = text.length >= minPassSymbols
                viewLayer?.setButtonEnable(status)
            }
        default:
            viewLayer?.setButtonEnable(false)
        }
    }
    
    func strength(text: String, type: UnderlineTextFieldStyle) {
        guard type == .pass else {
            return
        }
        let strength = Strength(password: text)
        switch strength {
        case .empty:
            viewLayer?.updateIndicator(with: .empty)
        case .weak, .veryWeak:
            viewLayer?.updateIndicator(with: .weak)
        case .reasonable:
            viewLayer?.updateIndicator(with: .med)
        case .strong, .veryStrong:
            viewLayer?.updateIndicator(with: .strong)
        }
    }
}

private extension CreatePasswordPresenter {
    
    func save(_ password: String) {
        self.password = password
    }
    
    func createWallet() {
        viewLayer?.update(with: .loading)
        
        guard let password = password, let account = prepareAccount() else {
            return
        }
        
        walletManager.encryptWallet(password, account: account) { [weak self] (json) in

            guard let json = json else {
                return
            }

            if let documentsDirectory = EXACommon.documentsDirectory {
                let walletFilePath = documentsDirectory.appendPathComponent(AWConfiguration.shared.encryptedWalletFileName)
                guard let data = json.data(using: .utf8) else {
                    return
                }
                try? data.write(to: URL(fileURLWithPath: walletFilePath), options: [.atomic])
            }

            if let addressMain = self?.wallets?.address(.amoveo) {
                let walletInfo = OpenWalletInfo(address: addressMain)
                AppState.sharedInstance.walletInfo = walletInfo
                WalletsLoader().save()
            }

            self?.viewLayer?.update(with: .loaded)
            if let params = self?.params {
                if params.isPasswordChange {
                    self?.viewLayer?.showAlert()
                } else {
                    EXAAppNavigationDispatcher.sharedInstance.showWalletAfterCreate(params.isRestored)
                }
            }
        }
    }
    
    func prepareAccount() -> Account? {
        if params?.account != nil {
            return params?.account
        } else {
            guard let walletAccount = wallets?.account(.amoveo) else {
                print("CreatePasswordPresenter Error: unable get wallet account")
                return nil
            }
            return walletAccount
        }
    }
}
