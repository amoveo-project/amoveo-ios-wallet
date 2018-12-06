//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

typealias ResponseRawData = Data

protocol BalanceInterfaceAPIProtocol {

    func fetchBalance() -> Promise<ResponseRawData>
}

final class BalanceInterfaceAPI {

    private let apiBuilder = EXAAPIBuilder()
}

extension BalanceInterfaceAPI: BalanceInterfaceAPIProtocol {

    func fetchBalance() -> Promise<ResponseRawData> {
        return Promise { fulfil in

            guard let address = AppState.sharedInstance.walletInfo?.address else {
                return fulfil.reject(AWError.InvalidRequest) // TODO
            }

            guard let request = apiBuilder.buildApiRequest("balance",
                    textPayload: "[\"account\", \"\(address)\"]") else {
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
