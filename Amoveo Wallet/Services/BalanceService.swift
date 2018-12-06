//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

private enum AmountSign {
    case positive, negative
}

final class BalanceService {

    var onUpdate: BalanceUpdatedHandler?

    private let apiInterface = BalanceInterfaceAPI() as BalanceInterfaceAPIProtocol
    private let dataWorker = BalanceDataWorker()

    private var balanceStorage: BalanceStorageProtocol? {
        get { return AppState.sharedInstance.walletInfo?.balance }
    }
}

extension BalanceService: BalanceServiceProtocol {

    func update() {
        updateMain()
    }

    func update(_ type: WalletType) {
        switch type {
        case .amoveo:
            updateMain()
        }
    }
}

private extension BalanceService {

    func updateMain() {

        firstly {
            apiInterface.fetchBalance()
        }.then { (data: Data) -> Promise<[Balance]> in
            return self.dataWorker.work(with: data)
        }.done { (balance) in
            print("<< Got VEO Balances")
            self.addBalanceVEO(balance)
        }.catch { (error) in
            print("Balance Service: Error - \(error)")
        }
    }
}

private extension BalanceService {

    func addBalanceVEO(_ balance: [Balance]) {

        let balanceVEO = amount(from: balance, with: .VEO)
        update(with: balanceVEO, type: .VEO)

        onUpdate?()
    }

    func amount(from balance: [Balance], with type: CryptoTicker) -> AmountValue? {
        return balance.filter{$0.type == type}.first?.value
    }

    func update(with amount: AmountValue?, type: CryptoTicker) {
        guard let balanceStorage = balanceStorage else {
            print("BalanceService: Error unable to get wallet info")
            return
        }
        let sign = compareForAmountSign(with: amount)
        switch sign {
        case .positive:
            addForPositiveSign(balanceStorage, type, amount)
        case .negative:
            addForNegativeSign(balanceStorage, type)
        }
    }
}

private extension BalanceService {

    func compareForAmountSign(with amount: AmountValue?) -> AmountSign {
        guard let balanceAmount = amount, balanceAmount.isNegative else {
            return .positive
        }
        return .negative
    }

    func addForPositiveSign(_ balanceStorage: BalanceStorageProtocol, _ type: CryptoTicker, _ amount: AmountValue?) {
        guard let amount = amount else {
            return
        }
        balanceStorage.setBalance(amount: amount, for: type)
    }

    func addForNegativeSign(_ balanceStorage: BalanceStorageProtocol, _ type: CryptoTicker) {
        let zeroValue = AmountValue.constantZero()
        let amount = balanceStorage.getBalance(ticker: type)
        balanceStorage.setBalance(amount: amount ?? zeroValue, for: type)
    }
}
