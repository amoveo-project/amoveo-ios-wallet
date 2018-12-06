//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class AmoveoWallet: WalletProtocol {

    var name: String
    var account: Account
    var address: Address?
    var type: WalletType = .amoveo

    init(account: Account) {
        self.name = "Amoveo Wallet"
        self.account = account
        self.address = account.address
    }
}
