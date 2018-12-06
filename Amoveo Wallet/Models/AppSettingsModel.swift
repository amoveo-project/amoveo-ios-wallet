//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class AppSettingsModel {

    var showOnboarding: Bool {
        get {
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AWDefaults.isShowOnboarding.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    var skippedPass: Bool { // TODO: Migration later
        get {
            return UserDefaults.standard.bool(forKey: AWDefaults.skippedPassword.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AWDefaults.skippedPassword.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    var blockchainNodeAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: AWDefaults.blockchainNodeAddress.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AWDefaults.blockchainNodeAddress.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    var selectedCurrency: AlternativeCurrency {
        get {
            if let v = UserDefaults.standard.string(forKey: AWDefaults.alternativeCurrency.rawValue) {
                return AlternativeCurrency(rawValue: v) ?? AlternativeCurrency.EUR
            }

            return AlternativeCurrency.EUR
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: AWDefaults.alternativeCurrency.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    var showInDashboard: AlternativeCurrencyTypeShow {
        get {
            let v = UserDefaults.standard.integer(forKey: AWDefaults.alternativeCurrencyTypeShow.rawValue)
            return AlternativeCurrencyTypeShow(rawValue: v) ?? AlternativeCurrencyTypeShow.rate
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: AWDefaults.alternativeCurrencyTypeShow.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    func reset() {
        UserDefaults.standard.set(nil, forKey: PinCodeConstants.kPincodeDefaultsKey)
        for setting in AWDefaults.all {
            UserDefaults.standard.set(nil, forKey: setting.rawValue)
        }

        AppBioAuthenticationControl().work(false)
        UserDefaults.standard.synchronize()
    }
}
