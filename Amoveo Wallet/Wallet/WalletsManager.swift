//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol WalletsManagerProtocol {
    func append(_ wallet: WalletProtocol, type: WalletType)
    func setupAccount(_ account: Account)
    func address(_ type: WalletType) -> Address?
    func account(_ type: WalletType) -> Account?
    func reset()
}

final class WalletsManager {
    
    private var walletAmoveo: WalletProtocol?

    init(account: Account) {
        setupAccount(account)
    }
    
    init(_ wallets: [WalletProtocol]) {
        setup(wallets)
    }
    
    func append(_ wallet: WalletProtocol, type: WalletType) {
        switch type {
        case .amoveo:
            walletAmoveo = wallet
        }
    }

    func setupAccount(_ account: Account) {
        walletAmoveo = AmoveoWallet(account: account)
    }
}

extension WalletsManager: WalletsManagerProtocol {
    
    func address(_ type: WalletType) -> Address? {
        switch type {
        case .amoveo:
            return walletAmoveo?.address
        }
    }
    
    func account(_ type: WalletType) -> Account? {
        switch type {
        case .amoveo:
            return walletAmoveo?.account
        }
    }
    
    func reset() {
        walletAmoveo = nil
    }
}

private extension WalletsManager {
    
    func setup(_ wallets: [WalletProtocol]) {
        walletAmoveo = wallets.filter{$0.type == .amoveo}.first
    }
}

