//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SignedTransactionSerializer: Jsonable {
    private var _signedTransaction: SignedTransaction?

    private init() {}

    init(_ transaction: SignedTransaction) {
        _signedTransaction = transaction
    }

    func json() -> JSON? {
        guard let stx = _signedTransaction else { return nil }
        guard let ptx = stx.preparedTransaction else { return nil }

        let arrIdentifier: Int = -6
        let arrTopic: JSON = [arrIdentifier]
        let innerTx: JSON
        if ptx.haveVersion {
            innerTx = [ptx.translatedType.rawValue, ptx.from, ptx.nonce, ptx.fee, ptx.to, ptx.amount, ptx.version!]
        } else {
            innerTx = [ptx.translatedType.rawValue, ptx.from, ptx.nonce, ptx.fee, ptx.to, ptx.amount]
        }

        let signedTx: JSON = ["signed", innerTx, stx.signature, arrTopic]
        let tx: JSON = [arrIdentifier, signedTx]
        let txs: JSON = ["txs", tx]

        return txs
    }
}
