//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

protocol SelectTransactionTypeAPIProtocol {

    func selectTransactionType(_ address: AddressSerializer) -> Promise<ResponseJSONData>
}

final class SelectTransactionTypeAPI {

    private let apiBuilder = EXAAPIBuilder()
}

extension SelectTransactionTypeAPI: SelectTransactionTypeAPIProtocol {

    func selectTransactionType(_ address: AddressSerializer) -> Promise<ResponseJSONData> {
        return Promise { fulfil in

            guard let request = apiBuilder.buildApiRequest("selectTransactionType", payload: address) else {
                return fulfil.reject(AWError.InvalidRequest)
            }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let theResponse = (response as? HTTPURLResponse) {
                    debugPrint(theResponse)
                    if EXAResponseChecker.success(theResponse) {
                        if let theData = data {
                            if let json = try? JSON(data: theData) {
                                if json[0] == "ok" {
                                    fulfil.fulfill(json[1])
                                }
                            }
                        }
                    } else {
                        fulfil.reject(error ?? AWError.ErrorResponse)
                    }
                }
            }.resume()
        }
    }
}
