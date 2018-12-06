//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class BalanceStorage {

    private let queue = DispatchQueue(label: "Amoveo.BalanceStorage.threadSafe", attributes: .concurrent)
    private var amountVEO = AmountVEO()
}

extension BalanceStorage: BalanceStorageProtocol {

    func setBalance(amount: AmountValue?, for ticker: CryptoTicker) {
        switch ticker {
        case .VEO:
            setBalanceForVEO(amount)
        }
    }

    func setBalance(amount: String?, for ticker: CryptoTicker) {
        // TODO: Implement or remove
    }

    func getBalance(ticker: CryptoTicker) -> AmountValue? {
        switch ticker {
        case .VEO:
            return getVEOAmount()
        }
    }
}

private extension BalanceStorage {

    func setBalanceForVEO(_ amount: AmountValue?) {
        queue.async(flags: .barrier) {
            self.amountVEO.amount = amount
        }
    }
}

private extension BalanceStorage {

    func getVEOAmount() -> AmountValue? {
        var amount: AmountValue?
        queue.sync {
            amount = self.amountVEO.amount
        }
        return amount
    }
}
