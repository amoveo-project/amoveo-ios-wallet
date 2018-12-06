//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class EXAResponseChecker {

    class func success(_ response: HTTPURLResponse) -> Bool {
        return (200...299 ~= response.statusCode)
    }
}
