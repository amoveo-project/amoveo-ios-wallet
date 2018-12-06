//
// Created by Igor Efremov on 22/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class AppLinker {
    
    var navigation: AppNavigationProtocol?
    
    private let comparator = AppLinkerComparator()
    private var addressLinker: AppLinkerAddressWalletProtocol?
    
    func handle(with url: URL) {
        transition(for: url)
    }
}

private extension AppLinker {
    
    func transition(for url: URL) {
        let type = comparator.compare(url)
        switch type {
        case .addressToSend:
            addressLinker = AppLinkerAddressWallet()
            addressLinker?.navigation = navigation
            addressLinker?.addressTransition(with: url)
        case .none:
            break
        }
    }
}
