//
// Created by Igor Efremov on 22/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

struct AppLinkerAddressWalletParams {
    
    enum AppLinkerAddressWalletKeys: String {
        case address, amount
    }
    
    var address: String?
    var amount : String?
}
