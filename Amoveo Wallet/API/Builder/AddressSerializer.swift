//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddressSerializer: Jsonable {
    private var _address: Address?

    private init() {}

    init(_ address: Address) {
        _address = address
    }

    func json() -> JSON? {
        guard let theAddress = _address else { return nil }

        let result: JSON = ["account", theAddress]
        return result
    }
}
