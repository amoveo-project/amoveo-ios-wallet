//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

typealias AmountValue = Double // TODO: replace on BigNumber

extension AmountValue {
    var isNegative: Bool {
        return self < 0.0
    }

    static func constantZero() -> AmountValue {
        return AmountValue(0.0)
    }
}

struct Balance {

    var value: AmountValue?
    var type: CryptoTicker = .VEO
}
