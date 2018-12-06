//
//  WalletFabric.swift
//
//  Created by Vladimir Malakhov on 03/08/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol WalletFabricProtocol {
    func makeWallets(for walletTypes: [WalletType], commonAccount: Account) -> [WalletProtocol]
}

final class WalletFabric: WalletFabricProtocol {
    
    func makeWallets(for walletTypes: [WalletType], commonAccount: Account) -> [WalletProtocol] {
        var appWallets = [WalletProtocol]()
        walletTypes.forEach { (type) in
            let wallet = makeWallet(for: type, account: commonAccount)
            appWallets.append(wallet)
        }
        return appWallets
    }
}

private extension WalletFabric {
    
    func makeWallet(for type: WalletType, account: Account) -> WalletProtocol {
        switch type {
        case .amoveo:
            return makeMainWallet(account)
        }
    }
    
    func makeMainWallet(_ commonAccount: Account) -> WalletProtocol {
        return AmoveoWallet(account: commonAccount)
    }
}

