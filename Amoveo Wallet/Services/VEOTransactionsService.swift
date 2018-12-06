//
// Created by Igor Efremov on 24/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class VEOTransactionsService: TransactionsService {

    func sendTransaction(_ currency: CryptoTicker, details: SendTransactionDetails) -> (Bool, String) {
        // TODO: Implement
        print("sendTransaction is NOT implemented")
        return (false, "")
    }

    func prepareAndSign(_ transaction: Transaction) -> Transaction {
        // TODO: Implement
        print("prepareAndSign is NOT implemented")
        return transaction
    }
}
