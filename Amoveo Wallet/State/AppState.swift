//
//  AppState.swift
//  Amoveo Wallet
//
//  Created by Igor Efremov on 10/01/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class AppState {
    static let sharedInstance = AppState()
    
    var isBiometryPresent = false
    var walletInfo: OpenWalletInfo?
    var walletsManager: WalletsManagerProtocol?
    var walletAddress: String?
    var settings: AppSettingsModel = AppSettingsModel()

    var currentRate: Double? = nil

    init() {}
    func restore() {}

    func save() {
        WalletsLoader().save()
    }

    func reset() {
        settings.reset()
    }
}

