//
// Created by Igor Efremov on 12/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol TransactionAttributesList: class {
    func txAttribute(by attribute: TransactionAttribute) -> String?
    func attribute(by index: Int) -> TransactionAttribute
    func notEmptyAttributesCount() -> Int
    func txType() -> TransactionType
}

enum EXATableCellInfoType: Int {
    case content, action
}

enum TransactionAttribute: Int {
    case date = 0, amount, alternativeAmount, txHash, to, from, confirmations, fee, viewInBlockchainAction
    static let all = [date, to, from, amount, txHash, fee, confirmations, viewInBlockchainAction]
    static let orderedList = [to, from, date, fee, txHash, viewInBlockchainAction]

    var type: EXATableCellInfoType {
        switch self {
        case .viewInBlockchainAction:
            return .action
        default:
            return .content
        }
    }

    var description: String {
        switch self {
        case .to:
            return "To"
        case .from:
            return "From"
        case .date:
            return "When"
        case .amount:
            return "Amount"
        case .alternativeAmount:
            return "Alternative amount"
        case .txHash:
            return "Tx hash"
        case .confirmations:
            return "Confirmations"
        case .fee:
            return "Fee"
        case .viewInBlockchainAction:
            return l10n(.viewInBlockchain)
        }
    }

    var height: Int {
        switch self {
        case .txHash:
            return 98
        case .to, .from:
            return 128
        case .viewInBlockchainAction:
            return 80
        default:
            return 60
        }
    }
}
