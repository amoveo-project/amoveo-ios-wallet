//
//  ReceiveAddressList.swift
//
//
//  Created by Igor Efremov on 06/08/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

typealias AddressEntryHandler = ((Address?) -> ())

protocol ReceiveViewModelProtocol {
    
    var onChangedWallet: AddressEntryHandler? { get set }
}

final class ReceiveViewModel {
    
    var onChangedWallet: AddressEntryHandler?
    var onSetupMainAddress: AddressEntryHandler?
    
    var type: WalletType = .amoveo {
        didSet {
            let address = currentAddress
            switch type {
            case .amoveo:
                onChangedWallet?(address)
            }
        }
    }
    var mainAddress: Address? {
        didSet {
            onSetupMainAddress?(mainAddress)
        }
    }

    var currentAddress: Address? {
        get {
            switch type {
            case .amoveo:
                return mainAddress
            }
        }
    }
}
