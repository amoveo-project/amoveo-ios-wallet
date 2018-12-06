//
// Created by Igor Efremov on 07/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

protocol PendingTransactionsInterfaceAPIProtocol {

    func fetchPending() -> Promise<ResponseRawData>
}

final class PendingTransactionsInterfaceAPI: PendingTransactionsInterfaceAPIProtocol {

    private let apiBuilder = EXAAPIBuilder()

    func fetchPending() -> Promise<ResponseRawData> {
        return Promise { fulfil in

            guard let _ = AppState.sharedInstance.walletInfo?.address else {
                return fulfil.reject(AWError.InvalidRequest) // TODO
            }

            guard let request = apiBuilder.buildApiRequest("pending",
                    textPayload: "[\"txs\"]") else {
                return fulfil.reject(AWError.InvalidRequest)
            }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let theResponse = (response as? HTTPURLResponse) {
                    debugPrint(theResponse)
                    if let theData = data {
                        fulfil.fulfill(theData)
                    }
                } else {
                    fulfil.reject(error!)
                }
            }.resume()
        }
    }
}
