//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON

class TransactionTemplateBuilder: Jsonable {
    private var _template: TransactionTemplate?

    private init() {}

    init(_ template: TransactionTemplate) {
        _template = template
    }

    func json() -> JSON? {
        guard let t = _template else { return nil }
        let result: JSON? = [t.type.rawValue, t.amount, t.fee, t.from, t.to]

        return result
    }
}
