//
//  EXAAppInfoService.swift
//
//
//  Created by Igor Efremov on 22/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class EXAAppInfoService {
    static var appTitle: String {
        return l10n(.commonAppTitle)
    }

    static var appVersion: String {
        var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            version += ".\(build)"
        }
        return version
    }

    static let telegramChannel: String = "Amoveo community"
    static let telegramChannelLink: String = "https://t.me/amoveo"
    static let explorerServiceBaseUrl: String = "https://amoveo.exan.tech/explorer/api/v1/txlist?address="
    static let crossRatesServiceUrl: String = "https://api-demo.exante.eu"
    static let oldExplorerServiceBaseUrlString = "https://explorer.veopool.pw/?input="
}

