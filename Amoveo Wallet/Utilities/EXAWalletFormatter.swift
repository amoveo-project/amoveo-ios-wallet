//
// Created by Igor Efremov on 28/06/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class EXAWalletFormatter {
    static let transactionDateFormat = "dd.MM.YYYY HH:mm"

    class func prepareAmount(rawAmount: UInt64) -> AmountValue {
        let amountNumber = NSDecimalNumber(value: rawAmount)
        let amountVEO = amountNumber.multiplying(byPowerOf10: -8)

        return AmountValue(truncating: amountVEO)
    }

    class func formattedAmount(_ preformattedAmount: String?) -> String? {
        guard let thePreformattedAmount = preformattedAmount else { return nil }
        let parts = thePreformattedAmount.split(separator: ".", omittingEmptySubsequences: true)
        var result: String = thePreformattedAmount
        if parts.count == 2  {
            var fractPart = parts[1]
            if fractPart.count > 2 {
                while fractPart.hasSuffix("0") && fractPart.count > 2 {
                    fractPart.removeLast()
                }
            }

            result = "\(parts[0]).\(fractPart)"
        }

        return result
    }

    class func total(in currency: AlternativeCurrency, amount: AmountValue, rateValue: Double) -> String {
        return (rateValue * amount).toCurrencyString(currency)
    }

    class func rate(in currency: AlternativeCurrency, rateValue: Double) -> String {
        return "1 VEO = \(rateValue.toCurrencyString(currency))"
    }

    class func alternativeAmount(type: AlternativeCurrencyTypeShow, currency: AlternativeCurrency, amount: AmountValue, rateValue: Double) -> String {
        switch type {
        case .rate:
            return rate(in: currency, rateValue: rateValue)
        case .total:
            return total(in: currency, amount: amount, rateValue: rateValue)
        }
    }
}
