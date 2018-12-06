//
// Created by Igor Efremov on 24/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol SendTransactionDetails {
    var from: Address? { get }
    var to: Address? { get }
    var amount: Double? { get }
}


class AmoveoSendTransactionDetails: SendTransactionDetails {
    private var _amount: Double?
    private var _to: Address?
    private var _from: Address?

    var from: Address? {
        return _from
    }
    var to: Address? {
        return _to
    }
    var amount: Double? {
        return _amount
    }

    init(amount: Double?, to: Address, from: Address) {
        _amount = amount
        _to = to
        _from = from
    }
}
