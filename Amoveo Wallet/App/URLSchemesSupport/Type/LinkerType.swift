//
// Created by Igor Efremov on 22/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum LinkerType {
    
    enum WalletAddress: String {
        
        case amoveo
        case unknown
        
        var tickerKey: String {
            switch self {
            case .amoveo:
                return "amoveo"
            case .unknown:
                return ""
            }
        }
        
        var amountKey: String {
            switch self {
            case .amoveo:
                return "amount"
            case .unknown:
                return ""
            }
        }
        
        static var allKeys = [WalletAddress.amoveo.tickerKey]
    }
}
