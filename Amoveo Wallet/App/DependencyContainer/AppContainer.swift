//
//  AppContainer.swift
//
//
//  Created by Igor Efremov on 30/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol AppContainerProtocol {
    
    var interactor: AppInteractorProtocol { get }
    var appearance: AppUIAppearanceProtocol { get }
    var appWallet: WalletManagerProtocol { get }
    var navigationSequence: AppNavigationPointSequenceProtocol { get }
}

final class AppContainer: AppContainerProtocol {

    var interactor: AppInteractorProtocol
    var appearance: AppUIAppearanceProtocol
    var appWallet: WalletManagerProtocol
    var navigationSequence: AppNavigationPointSequenceProtocol
    
    init() {
        interactor = AppInteractor()
        appearance = AppUIAppearance()
        appWallet = WalletManager()
        navigationSequence = AppNavigationPointSequence(PincodeTimer())
    }
}
