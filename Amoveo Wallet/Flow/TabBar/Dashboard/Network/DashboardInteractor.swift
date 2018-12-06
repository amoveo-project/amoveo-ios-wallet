//
//  DashboardInteractor.swift
//
//
//  Created by Igor Efremov on 17/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TransactionUpdateRule {
    case getfromLocal, updateUI
}

typealias BalanceStatusFullCallback = (Bool) -> ()
typealias BalanceUpdatedCallback = ([Balance]) -> ()
typealias LastCourseUpdatedCallback = ((Double) -> ())
typealias UnconfirmedTransactionsCountCallback = ((Int) -> ())
typealias TransactionsUpdatedCallback = ((TransactionUpdateRule) -> ())
typealias CrossRateUpdatedCallback = ((Double, String) -> ())

protocol DashboardInteractorProtocol {
    
    var onAllBalancesUpdated: BalanceUpdatedCallback? { get set }
    var onTransactionsUpdated: TransactionsUpdatedCallback? { get set }
    var onCrossRateUpdated: CrossRateUpdatedCallback? { get set }
    
    func fetchBalance()
    func fetchCrossRate()
    func fetchTransactions(_ force: Bool)

    func startFetchingTransactions()
    func stopFetchingTransactions()

    func updateBalanceFromLocalWallet(balance: @escaping BalanceUpdatedCallback)
    
    func getTransactionList() -> [CommonTransaction]?
}

final class DashboardInteractor {
    var rateValue: Double = 0.0
    
    var onAllBalancesUpdated: BalanceUpdatedCallback?
    var onTransactionsUpdated: TransactionsUpdatedCallback?
    var onCrossRateUpdated: CrossRateUpdatedCallback?
    
    let transactionModel = AppState.sharedInstance.walletInfo?.transactionsModel

    private let transactionTimer = EXATimer(.transaction)
    
    deinit {
        transactionTimer.suspend()
    }
}

extension DashboardInteractor: DashboardInteractorProtocol {
    
    func fetchBalance() {
        updateBalance()
    }

    func fetchCrossRate() {
        updateCrossRate()
    }

    func startFetchingTransactions() {
        transactionTimer.resume()
        transactionTimer.eventHandler = { [weak self] in
            self?.fetchTransactions(true)
            self?.fetchCrossRate()
        }
    }

    func stopFetchingTransactions() {
        transactionTimer.suspend()
    }
    
    func fetchTransactions(_ force: Bool) {
        updateTransactionHistory()
        updatePendingTransactions()
    }
    
    func getTransactionList() -> [CommonTransaction]? {
        return transactionModel?.listOfTransactions()
    }
}
