//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

typealias ResponseJSONData = JSON

protocol TransactionCreationInterfaceAPIProtocol {

    func createTransaction(_ template: TransactionTemplateBuilder) -> Promise<ResponseJSONData>
}

final class TransactionCreationInterfaceAPI {

    private let apiBuilder = EXAAPIBuilder()
}

extension TransactionCreationInterfaceAPI: TransactionCreationInterfaceAPIProtocol {

    func createTransaction(_ template: TransactionTemplateBuilder) -> Promise<ResponseJSONData> {
        return Promise { fulfil in

            guard let _ = AppState.sharedInstance.walletInfo?.address else {
                return fulfil.reject(AWError.InvalidRequest) // TODO
            }

            guard let request = apiBuilder.buildApiRequest("createTransaction", payload: template) else {
                return fulfil.reject(AWError.InvalidRequest)
            }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let theResponse = (response as? HTTPURLResponse) {
                    debugPrint(theResponse)
                    if let theData = data {
                        if let json = try? JSON(data: theData) {
                            if json[0] == "ok" {
                                fulfil.fulfill(json[1])
                            }
                        }
                    }
                } else {
                    fulfil.reject(error!)
                }
            }.resume()
        }
    }
}
