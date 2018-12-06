//
// Created by Igor Efremov on 07/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

final class PendingTransactionsDataWorker {

    func work(with data: ResponseRawData) -> Promise<[TransactionTemplate]> {
        return Promise { fulfil in
            fulfil.fulfill(parseTransactions(data))
        }
    }

    private func parseTransactions(_ rawTransactions: ResponseRawData) -> [TransactionTemplate] {
        return innerParseTransactions(rawTransactions)
    }

    private func innerParseTransactions(_ rawTransactions: ResponseRawData) -> [TransactionTemplate] {
        var txs = [TransactionTemplate]()

        let json = JSON(rawTransactions)
        let transactionsCount = json[1].count
        if transactionsCount > 0 {
            for index in 1...transactionsCount {
                let transactionRaw = json[1][index][1]
                let transactionUUID = json[1][index][2].stringValue
                let rawType = transactionRaw[0].stringValue
                if let theType = TranslatedTransactionType(rawValue: rawType) {
                    let tx = TransactionTemplate(theType.blockChainType, amount: transactionRaw[5].uInt64 ?? 0,
                            from: transactionRaw[1].stringValue, to: transactionRaw[4].stringValue)
                    tx.uuid = transactionUUID
                    tx.fee = transactionRaw[3].uInt64 ?? 0
                    tx.isPending = true
                    txs.append(tx)
                }

                debugPrint(transactionRaw)
            }
        }

        return txs
    }
}
