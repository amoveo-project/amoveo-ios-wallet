//
// Created by Igor Efremov on 27/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum AlternativeCurrency: String {
    case BTC, ETH, EUR, USD
    static let all = [BTC, ETH, EUR, USD]
    static let defaultIndex: Int = 2

    var precision: Int {
        switch self {
        case .EUR, .USD:
            return 2
        case .BTC, .ETH:
            return 8
        }
    }

    var index: Int {
        return AlternativeCurrency.all.firstIndex(of: self) ?? AlternativeCurrency.defaultIndex
    }
}

enum AlternativeCurrencyTypeShow: Int {
    case rate = 0, total
    static let all = [rate, total]

    var title: String {
        switch self {
        case .rate: return "Rate"
        case .total: return "Total"
        }
    }
}
