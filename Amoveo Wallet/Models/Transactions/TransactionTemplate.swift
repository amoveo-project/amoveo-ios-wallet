//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum TransactionTemplateField: Int {
    case translatedType = 0, from, nonce, fee, to, amount, version
    static let all = [translatedType, from, nonce, fee, to, amount, version]
}

class TransactionTemplate {
    var uuid: String? = nil
    var type: TransactionBlockchainType = .create_account_tx
    var amount: UInt64 = 0
    var fee: UInt64 = 0
    var from: Address = ""
    var to: Address = ""
    var isPending: Bool = false

    private init() {}

    init(_ type: TransactionBlockchainType, amount: UInt64, from: Address, to: Address) {
        self.type = type
        self.fee = type.fee
        self.amount = amount
        self.from = from
        self.to = to
    }
}

