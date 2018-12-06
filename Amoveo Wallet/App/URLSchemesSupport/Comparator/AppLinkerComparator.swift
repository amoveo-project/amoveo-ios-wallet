//
// Created by Igor Efremov on 22/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum LinkerComparatorType {
    
    case addressToSend
    case none
}

final class AppLinkerComparator {
    
    func compare(_ url: URL) -> LinkerComparatorType {
        if isValidAddress(url) {
            return .addressToSend
        } else {
            return .none
        }        
    }
}

private extension AppLinkerComparator {
    
    func isValidAddress(_ url: URL) -> Bool {
        guard let scheme = url.scheme else { return false}
        return LinkerType.WalletAddress.allKeys.contains(scheme)
    }
}
