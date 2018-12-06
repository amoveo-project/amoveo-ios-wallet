//
// Created by Igor Efremov on 11/04/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerRequest {
    fileprivate let innerPath: String
    fileprivate let innerType: HTTPMethod
    fileprivate var innerHeader: [String: String]?

    var pathToMethod: String {
        return innerPath
    }
    var type: HTTPMethod {
        return innerType
    }

    var header: [String: String]? {
        return innerHeader
    }

    init(_ path: String, type: HTTPMethod = .post, header: [String: String]? = nil) {
        innerPath = path
        innerType = type
        innerHeader = header
    }

    func addHeader(_ field: String, value: String) {
        if innerHeader == nil {
            innerHeader = [:]
        }

        innerHeader?[field] = value
    }
}

class AWJSONRequest: ServerRequest {
    var jsonParam: JSON?

    convenience init(_ path: String, type: HTTPMethod = .post) {
        self.init(path, type: type, header: ["Content-Type": "application/json"])
    }
}

