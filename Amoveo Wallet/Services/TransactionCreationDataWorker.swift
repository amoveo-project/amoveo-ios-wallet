//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

final class TransactionCreationDataWorker {

    func work(with data: ResponseJSONData) -> Promise<PreparedTransactionTemplate> {
        return Promise { fulfil in
            if let preparedTransaction = parseContent(content: data) {
                fulfil.fulfill(preparedTransaction)
            } else {
                fulfil.reject(AWError.InvalidRequest)
            }
        }
    }
}

private extension TransactionCreationDataWorker {

    func parseContent(content: ResponseJSONData) -> PreparedTransactionTemplate? {
        if content.count > 0 {
            if let rawType = content[0].string {
                if let type = TranslatedTransactionType(rawValue: rawType) {
                    guard let from: Address = content[1].string else { return nil }
                    guard let nonce: UInt64 = content[2].uInt64 else { return nil }
                    guard let to: Address = content[4].string else { return nil }
                    guard let amount: UInt64 = content[5].uInt64 else { return nil }
                    let version: UInt64? = content[6].uInt64 // special case

                    let preparedTransaction = PreparedTransactionTemplate(type, amount: amount, from: from, to: to)
                    preparedTransaction.nonce = nonce
                    preparedTransaction.version = version

                    return preparedTransaction
                }
            }
        }

        return nil
    }
}
