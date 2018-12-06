//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class SignedTransaction {
    private var _base64Signature: String?
    private var _preparedTransaction: PreparedTransactionTemplate?

    var signature: String {
        return _base64Signature ?? ""
    }

    var preparedTransaction: PreparedTransactionTemplate? {
        return _preparedTransaction
    }

    init(_ base64Signature: String, preparedTransaction: PreparedTransactionTemplate) {
        _base64Signature = base64Signature
        _preparedTransaction = preparedTransaction
    }
}
