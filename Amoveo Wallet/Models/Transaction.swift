//
// Created by Igor Efremov on 24/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import UIKit

enum TransactionType: Int, Codable {
    case received = 0, sent

    var description: String {
        switch self {
        case .sent: return "Sent"
        case .received: return "Received"
        }
    }

    var image: UIImage {
        switch self {
        case .sent: return EXAGraphicsResources.sendTab.tintImage(UIColor.awYellow)
        case .received: return EXAGraphicsResources.receiveTab.tintImage(UIColor.awYellow)
        }
    }
}

class Transaction {
    private var _rawDate: String? = nil

    var txHash: String = ""
    var destination: String = ""
    var ticker: CryptoTicker = .VEO
    var amountString: String? {
        return amount?.stringValue
    }
    var feeString: String?
    var amount: NSDecimalNumber?
    var type: TransactionType = .received
    var timestamp: TimeInterval = 0
    var confirmations: UInt64 = 0
    var date: String {
        return _rawDate ?? "unknown"
    }

    var pending: Bool = false

    init(_ txHash: String, _ amount: NSDecimalNumber?, _ timestamp: TimeInterval = 0, rawDate: String, _ type: TransactionType) {
        self.txHash = txHash
        self.amount = amount
        self.timestamp = timestamp
        self.type = type

        _rawDate = rawDate
    }

    class func transactionType(_ transaction: CommonTransaction) -> TransactionType {
        guard let address = AppState.sharedInstance.walletInfo?.address else { return .received } // TODO: Rewrite !!!
        if address.hasPrefix(transaction.from) {
            return .sent
        } else {
            return .received
        }
    }
}

extension Transaction: TransactionAttributesList {
    func txAttribute(by attribute: TransactionAttribute) -> String? {
        switch attribute {
        case .to:
            return (self.type == .sent) ? destination : nil
        case .from:
            return (self.type == .received) ? destination : nil
        case .txHash:
            return self.pending ? nil : txHash
        case .confirmations:
            return String(confirmations)
        case .amount:
            let theAmount = EXAWalletFormatter.formattedAmount(amountString) ?? "?"
            return "\(theAmount) \(CryptoTicker.VEO.description)"
        case .alternativeAmount:
            let currency = AppState.sharedInstance.settings.selectedCurrency
            if let theRate = AppState.sharedInstance.currentRate, let theAmount = amount {
                return (theAmount.doubleValue * theRate).toCurrencyString(currency)
            }

            return ""
        case .date:
            return date
        case .fee:
            let theAmount = EXAWalletFormatter.formattedAmount(feeString) ?? "?"
            return "\(theAmount) \(CryptoTicker.VEO.description)"
        case .viewInBlockchainAction:
            return self.pending ? nil : txHash
        }
    }

    func notEmptyAttributesCount() -> Int {
        var result = 0
        for attrName in TransactionAttribute.orderedList {
            if let theAttribute = txAttribute(by: attrName), theAttribute.length > 0 {
                result += 1
            }
        }

        return result
    }

    func attribute(by index: Int) -> TransactionAttribute {
        let attrs = TransactionAttribute.orderedList.filter{txAttribute(by: $0) != nil && txAttribute(by: $0) != ""}
        return attrs[index] // TODO: check for out-of-boundary
    }

    func txType() -> TransactionType {
        return self.type
    }
}

