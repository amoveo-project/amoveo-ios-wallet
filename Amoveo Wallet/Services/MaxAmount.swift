//
// Created by Igor Efremov on 19/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class MaxAmount {
    static func maxAmount(availableAmount: AmountValue, fee: AmountValue) -> AmountValue {
        let amountNumber = NSDecimalNumber(value: 1)
        let amountVEO = AmountValue(truncating: amountNumber.multiplying(byPowerOf10: -8))
        return availableAmount - fee - amountVEO
    }
}
