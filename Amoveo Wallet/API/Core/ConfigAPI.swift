//
// Created by Igor Efremov on 22/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum AmoveoEnvironment {
    case production

    var url: URL? {
        return AWConfiguration.shared.serverConfiguration.url
    }

    var explorer: String {
        return AWConfiguration.shared.explorerServiceUrlString
    }

    var crossRates: URL? {
        return AWConfiguration.shared.serverConfiguration.url
    }
}
