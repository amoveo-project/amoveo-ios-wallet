//
// Created by Igor Efremov on 07/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

protocol PendingTransactionsHistoryServiceProtocol {

    var onUpdate: TransactionHistoryUpdatedHandler? { get set }
    func update()
}

final class PendingTransactionsInfoService: PendingTransactionsHistoryServiceProtocol {
    private let api = PendingTransactionsInterfaceAPI() as PendingTransactionsInterfaceAPIProtocol
    private let dataWorker = PendingTransactionsDataWorker()

    private var walletInfo: OpenWalletInfo? {
        get { return AppState.sharedInstance.walletInfo }
    }

    var onUpdate: TransactionHistoryUpdatedHandler?

    func update() {
        fetchPendingTransactions()
    }

    func fetchPendingTransactions() {
        //group.enter()
        print("Fetch VEO pending transactions history")
        //group.enter()

        firstly {
            api.fetchPending()
        }.then { (contentData: ResponseRawData) -> Promise<[TransactionTemplate]> in
            return self.dataWorker.work(with: contentData)
        }.done { (pendingTransactions) in
            print(pendingTransactions)
            print("<< Got Pending \(pendingTransactions)")
            self.addVEOPendingTransactions(pendingTransactions)
            self.onUpdate?()
        }.catch { (error) in
            print("Pending transactions Service: Error - \(error)")
        }
    }

    private func isOwnTransaction(_ transaction: CommonTransaction) -> Bool {
        guard let address = AppState.sharedInstance.walletInfo?.address else { return false }
        return (address.hasPrefix(transaction.from) || address.hasPrefix(transaction.to))
    }

    func addVEOPendingTransactions(_ transactions: [TransactionTemplate]?) {
        if let arr = (walletInfo?.transactionDictionaryHistory.filter{ $1.pending == true }) {
            for key in arr.keys {
                walletInfo?.transactionDictionaryHistory.removeValue(forKey: key)
            }
        }

        if let veoTransactions = transactions, veoTransactions.count != 0 {
            var foundTransactions: [String] = [String]()
            for index in 0..<veoTransactions.count {
                let txTemplate = veoTransactions[index]
                let amountVEO = EXAWalletFormatter.prepareAmount(rawAmount: txTemplate.amount)
                let amountString: String = EXAWalletFormatter.formattedAmount(amountVEO.toVEOString()) ?? "?"

                let tx = CommonTransaction(uuid: txTemplate.uuid ?? "unknownUUID", amount: amountString, timestamp: UInt64( Date().timeIntervalSince1970 ))
                tx.from = txTemplate.from
                tx.to = txTemplate.to
                tx.fee = EXAWalletFormatter.prepareAmount(rawAmount: txTemplate.fee).toVEOString()
                tx.pending = true

                if isOwnTransaction(tx) {
                    walletInfo?.transactionDictionaryHistory[tx.uuid] = tx
                    foundTransactions.append(tx.uuid)
                }
            }
        }
    }
}
