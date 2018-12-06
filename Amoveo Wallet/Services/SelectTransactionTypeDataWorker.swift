//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

final class SelectTransactionTypeDataWorker {

    func work(with data: ResponseJSONData) -> Promise<TransactionBlockchainType> {
        return Promise { fulfil in
            let transactionType = parseContent(content: data)
            fulfil.fulfill(transactionType)
        }
    }
}

private extension SelectTransactionTypeDataWorker {

    func parseContent(content: ResponseJSONData) -> TransactionBlockchainType {
        if let theString = content.string {
            if theString == "empty" {
                return .create_account_tx
            }
        }

        return .spend_tx
    }
}
