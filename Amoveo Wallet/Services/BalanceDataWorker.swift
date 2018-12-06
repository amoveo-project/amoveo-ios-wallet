//
//  BalanceDataWorker.swift
//
//  Created by Vladimir Malakhov on 23/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

private enum Param {
    
    case VEO
    
    var key: String {
        switch self {
        case .VEO:
            return "veo"
        }
    }
}

private enum BalanceResponseFormat: Int {
    case status = 0, content

    enum ContentFormat: Int {
        case amount = 1
    }
}

final class BalanceDataWorker {
    
    func work(with data: ResponseRawData) -> Promise<[Balance]> {
        return Promise { fulfil in

            if let amountVEO = parseAmount(data: data) {
                let balanceVEO = Balance(value: AmountValue(amountVEO), type: .VEO)
                fulfil.fulfill([balanceVEO])
            } else {
                fulfil.reject(AWError.InvalidRequest)
            }
        }
    }
}

private extension BalanceDataWorker {
    
    func parseAmount(data: ResponseRawData) -> AmountValue? {
        let json = JSON(data)
        if let amount = json[BalanceResponseFormat.content.rawValue][BalanceResponseFormat.ContentFormat.amount.rawValue].uInt64 {
            return EXAWalletFormatter.prepareAmount(rawAmount: amount)
        }

        return nil
    }
    
    /*func parseUnconfirmedAmount(dict: [String: Any]) -> BigNumber? {
        guard let amount = dict["unconfirmedBalanceSat"] as? NSNumber else {
            return nil
        }
        return BigNumber(number: amount)
    }*/
}
