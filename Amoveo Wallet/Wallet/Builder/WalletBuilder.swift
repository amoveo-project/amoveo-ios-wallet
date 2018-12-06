//
//  WalletBuilder.swift
//
//  Created by Vladimir Malakhov on 03/08/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class WalletBuilder {
    
    func buildAll(with account: Account) {
        let walletCollection = makeWallets(account: account, wallets: [.amoveo])
        setupWallets(walletCollection)
    }
}

private extension WalletBuilder {
    
    func makeWallets(account: Account, wallets: [WalletType]) -> [WalletProtocol] {
        let walletFabric = WalletFabric()
        let wallets = walletFabric.makeWallets(for: wallets, commonAccount: account)
        return wallets
    }
    
    func setupWallets(_ wallets: [WalletProtocol]) {
        let walletsManager = WalletsManager(wallets)
        AppState.sharedInstance.walletsManager = walletsManager
    }
}
