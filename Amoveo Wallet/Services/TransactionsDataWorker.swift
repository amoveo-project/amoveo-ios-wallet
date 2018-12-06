//
// Created by Igor Efremov on 23/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

final class TransactionsDataWorker {

    func work(with data: ResponseRawData) -> Promise<[CommonTransaction]> {
        return Promise { fulfil in

            if let transactionsList = parseTransactions(data: data) {
                fulfil.fulfill(transactionsList)
            } else {
                fulfil.reject(AWError.InvalidRequest)
            }
        }
    }
}

private extension TransactionsDataWorker {

    func parseTransactions(data: ResponseRawData) -> [CommonTransaction]? {
        var transactionsList: [CommonTransaction] = [CommonTransaction]()

        let json = JSON(data)
        let rawHistory = json["result"]
        let count = rawHistory.count
        if count > 0 {
            for index in 0..<count {
               if let theHash = rawHistory[index]["hash"].string {
                   let amount = rawHistory[index]["amount"].uInt64 ?? 0
                   let fee = rawHistory[index]["fee"].uInt64 ?? 0
                   let timestamp = rawHistory[index]["timestamp"].uInt64 ?? 0

                   let amountString = EXAWalletFormatter.prepareAmount(rawAmount: amount).toVEOString()
                   let feeString = EXAWalletFormatter.prepareAmount(rawAmount: fee).toVEOString()

                   let transaction: CommonTransaction = CommonTransaction(uuid: theHash, amount: amountString, fee: feeString, timestamp: timestamp)
                   transaction.to = rawHistory[index]["to"].string ?? ""
                   transaction.from = rawHistory[index]["from"].string ?? ""
                   transactionsList.append(transaction)
               } else {
                   continue
               }
            }

            return transactionsList
        } else {
            return nil
        }
    }
}
