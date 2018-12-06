//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

protocol TransactionSenderInterfaceAPIProtocol {

    func sendTransaction(_ signedTransaction: SignedTransactionSerializer) -> Promise<ResponseJSONData>
}

final class TransactionSenderInterfaceAPI {

    private let apiBuilder = EXAAPIBuilder()
}

extension TransactionSenderInterfaceAPI: TransactionSenderInterfaceAPIProtocol {

    func sendTransaction(_ signedTransaction: SignedTransactionSerializer) -> Promise<ResponseJSONData> {
        return Promise { fulfil in

            guard let _ = AppState.sharedInstance.walletInfo?.address else {
                return fulfil.reject(AWError.InvalidRequest) // TODO
            }

            guard let request = apiBuilder.buildApiRequest("sendTransaction", payload: signedTransaction) else {
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
