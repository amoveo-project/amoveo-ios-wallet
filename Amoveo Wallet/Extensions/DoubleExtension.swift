//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

extension Double {

    func toVEOString() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 8

        return nf.string(from: self as NSNumber)!
    }

    func toCurrencyString(_ currency: AlternativeCurrency) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = currency.precision

        return nf.string(from: self as NSNumber)! + " " + currency.rawValue
    }
}
