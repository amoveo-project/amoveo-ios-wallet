//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

typealias Address = String

protocol OpenWalletInfoProtocol {
    var balance: BalanceStorageProtocol { get }
    var address: Address? { get }
    var transactionDictionaryHistory: [String: CommonTransaction] { get set }
    var transactionsModel: TransactionsModel? { get set }
}
