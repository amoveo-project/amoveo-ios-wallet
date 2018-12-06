//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class PreparedTransactionTemplate: TransactionTemplate {
    var translatedType: TranslatedTransactionType = .create_acc_tx
    var nonce: UInt64 = 0
    var version: UInt64? = nil
    var haveVersion: Bool {
        return version != nil
    }

    var fieldCount: Int {
        return haveVersion ? TransactionTemplateField.all.count : TransactionTemplateField.all.count - 1
    }

    init(_ type: TranslatedTransactionType, amount: UInt64, from: Address, to: Address) {
        super.init(type.blockChainType, amount: amount, from: from, to: to)
        translatedType = type
    }

    subscript(index: Int) -> Any {
        get {
            if let field = TransactionTemplateField(rawValue: index) {
                switch field {
                case .translatedType:
                    return translatedType.rawValue
                case .from:
                    return from
                case .nonce:
                    return nonce
                case .fee:
                    return fee
                case .to:
                    return to
                case .amount:
                    return amount
                case .version:
                    return version ?? 0
                }
            }

            return ""
        }
    }
}
