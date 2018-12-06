//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

final class ExplorerInterfaceAPI {

    private let apiBuilder = EXAAPIBuilder()
}

extension ExplorerInterfaceAPI: ExplorerInterfaceAPIProtocol {

    func getTransactionList(_ address: String) -> Promise<ResponseRawData> {
        return Promise { fulfil in

            guard let request = apiBuilder.buildExplorerRequest(address) else {
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
