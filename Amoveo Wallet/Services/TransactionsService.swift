//
// Created by Igor Efremov on 02/07/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol TransactionsService {
    func sendTransaction(_ currency: CryptoTicker, details: SendTransactionDetails) -> (Bool, String)
    func prepareAndSign(_ transaction: Transaction) -> Transaction
}
