//
// Created by Igor Efremov on 17/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum AppCoordinatorState {
    case `default`, regular
}

protocol AppCoordinatorProtocol {

    var onReadyToRoute: DefaultCallback? { get set }

    func setupApp(with type: AppCoordinatorState)
    func updateUserFlow(with type: AppCoordinatorState)

    func saveAppData()
}

protocol AppInteractorProtocol {

    func updateData()
    func updateSettingData()
}

protocol AppUIAppearanceProtocol {
    func setupUI()
}

protocol WalletManagerProtocol {
    func encryptWallet(_ pass: String, account: Account, callback: @escaping ((String?) -> Void))
    func decryptWallet(_ pass: String, accessGranted: ((Account) -> Swift.Void)?, accessDenied: (() -> (Swift.Void))?)
}

protocol AppNavigationPointSequenceProtocol {
    // TODO add some methods
}
