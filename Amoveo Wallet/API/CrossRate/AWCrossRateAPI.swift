//
// Created by Igor Efremov on 16/04/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON

final class AWCrossRateAPI {
    private let apiRootName = "/md/1.0/"
    private let apiMethodCrossRate = "crossrates"
    private let toRate = "/VEO/"
    private let accessToken = AWConfiguration.shared.crossRatesServiceApiKey

    private var fromRate = "EUR"
    var rateTicker: String {
        return fromRate
    }

    func crossRateRequest() -> URLRequest {
        let theRequest = buildCrossRateRequest()
        let theUrl = URL(string: theRequest.pathToMethod)!
        var urlRequest = URLRequest(url: theUrl)
        urlRequest.httpMethod = theRequest.type.rawValue

        if let theHeader = theRequest.header {
            for headerField in theHeader.keys {
                if let value = theHeader[headerField] {
                    urlRequest.setValue(value, forHTTPHeaderField: headerField)
                }
            }
        }

        return urlRequest
    }

    private func buildCrossRateRequest() -> AWJSONRequest {
        // TODO: Replace on Bearer Authorization
        fromRate = AppState.sharedInstance.settings.selectedCurrency.rawValue
        let toFromRate = toRate + fromRate
        let request = AWJSONRequest(constructFullPath(to: apiMethodCrossRate + toFromRate), type: .get)
        request.addHeader("Authorization", value: "Basic \(accessToken)")

        return request
    }

    private func constructFullPath(to methodName: String) -> String {
        let serverUrl = AWConfiguration.shared.crossRatesServiceUrlString
        return "\(serverUrl)\(apiRootName)\(methodName)/"
    }
}
