//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class OpenWalletInfo: OpenWalletInfoProtocol {
    private var _address: Address?

    var balance = BalanceStorage() as BalanceStorageProtocol

    var address: Address? {
        return _address
    }

    var transactionDictionaryHistory: [String: CommonTransaction] = [String: CommonTransaction]()
    var transactionsModel: TransactionsModel? = nil

    init() {
        print("INIT OpenWalletInfo")
    }

    init(address: Address) {
        print("INIT OpenWalletInfo with \(address)")
        _address = address

        addTransactions()
    }
}

private extension OpenWalletInfo {

    func addTransactions() {
        transactionsModel = preloadTransactionsModel() ?? TransactionsModel()
    }

    func preloadTransactionsModel() -> TransactionsModel? {
        return nil
    }
}
