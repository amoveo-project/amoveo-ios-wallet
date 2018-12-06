//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum AWDefaults: String {
    case isShowOnboarding
    case skippedPassword
    case blockchainNodeAddress
    case alternativeCurrency
    case alternativeCurrencyTypeShow

    static let all = [isShowOnboarding, skippedPassword, blockchainNodeAddress, alternativeCurrency, alternativeCurrencyTypeShow]
}

class AWConfiguration {
    static let shared = AWConfiguration()

    private var _encryptedWalletFileName: String
    private var _explorerServiceUrlString: String
    private var _crossRatesServiceUrlString: String
    private var _serverConfiguration: ServerConfiguration
    private var _crossRatesServiceApiKey: String?

    var encryptedWalletFileName: String {
        return _encryptedWalletFileName
    }

    var explorerServiceUrlString: String {
        return _explorerServiceUrlString
    }

    var crossRatesServiceUrlString: String {
        return _crossRatesServiceUrlString
    }

    var crossRatesServiceApiKey: String {
        return _crossRatesServiceApiKey ?? ""
    }

    var serverConfiguration: ServerConfiguration {
        return _serverConfiguration
    }

    func loadConfiguration(url: URL?) -> Bool {
        guard let url = url else { return false }

        let port: Int
        let scheme: String

        if let thePort = url.port {
            port = thePort
        } else {
            port = 80
        }

        if let theScheme = url.scheme {
            scheme = theScheme
        } else {
            scheme = "http"
        }

        if let theHost = url.host {
            _serverConfiguration = BaseServerConfiguration(theHost, httpSecure: (scheme == "https"), stage: false, port: port)
            AppState.sharedInstance.settings.blockchainNodeAddress = url.absoluteString
            return true
        }

        return false
    }

    init() {
        if let theCrossRateApiKey = EXACommon.loadApiKey(AmoveoConstants.crossRateApiKeyPath) {
            _crossRatesServiceApiKey = theCrossRateApiKey
        }

        _encryptedWalletFileName = AmoveoConstants.encryptedWalletFile
        _explorerServiceUrlString = EXAAppInfoService.explorerServiceBaseUrl
        _crossRatesServiceUrlString = EXAAppInfoService.crossRatesServiceUrl
        _serverConfiguration = BaseServerConfiguration("amoveo.exan.tech", httpSecure: false, stage: false, port: 8080)
        if let theAddress = AppState.sharedInstance.settings.blockchainNodeAddress {
            _ = loadConfiguration(url: URL(string: theAddress))
        }
    }
}
