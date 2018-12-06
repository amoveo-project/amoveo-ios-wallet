//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

final class TransactionSendingDataWorker {

    func work(with data: ResponseJSONData) -> Promise<String> {
        return Promise { fulfil in
            if let txHash = parseContent(content: data) {
                fulfil.fulfill(txHash)
            } else {
                fulfil.reject(AWError.InvalidRequest)
            }
        }
    }
}

private extension TransactionSendingDataWorker {

    func parseContent(content: ResponseJSONData) -> String? {
        if let txHash = content.string {
            return txHash
        }

        return nil
    }
}
