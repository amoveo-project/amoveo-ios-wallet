//
// Created by Igor Efremov on 16/04/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

final class AWCrossRateService {

    var onUpdate: CrossRateUpdatedHandler?
    var onUpdateValue: CrossRateUpdatedValueHandler?
    let apiInterface = AWCrossRateAPI()

    func crossRate() -> PromiseKit.Promise<Double> {
        return Promise { result in
            Alamofire.request(apiInterface.crossRateRequest())
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success(let json):
                            let json = JSON(json)
                            guard let rate = json["rate"].double else {
                                return result.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                            }
                            result.fulfill(rate)
                        case .failure(let error):
                            result.reject(error)
                        }
                    }
        }
    }
}

extension AWCrossRateService: CrossRateServiceProtocol {

    func update() {
        firstly {
            crossRate()
        }.done { (balance) in
            print("<< Got VEO Cross Rate")
            self.onUpdateValue?(balance)
        }.catch { (error) in
            print("Cross Rate Service: Error - \(error)")
        }
    }
}

