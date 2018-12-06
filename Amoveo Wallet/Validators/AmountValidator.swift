//
// Created by Igor Efremov on 19/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class AmountValidator {

    static func isPossibleAmount(amount: AmountValue, availableAmount: AmountValue?, fee: AmountValue?) -> Bool {
        let feeValue = fee ?? 0.0
        guard let theAvailableAmount = availableAmount else { return false}
        return amount.isLessThanOrEqualTo(theAvailableAmount - feeValue)
    }
}
