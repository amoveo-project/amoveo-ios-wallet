//
// Created by Igor Efremov on 22/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

private typealias Params = AppLinkerAddressWalletParams

protocol AppLinkerAddressWalletProtocol {
    
    var navigation: AppNavigationProtocol? { get set }
    
    func addressTransition(with addressURL: URL)
    func addressParams(with addressURL: URL) -> AppLinkerAddressWalletParams?
}

final class AppLinkerAddressWallet: AppLinkerAddressWalletProtocol {
    
    var navigation: AppNavigationProtocol?
    
    func addressTransition(with addressURL: URL) {
        guard let params = parse(addressURL) else {
            return
        }
        routeToSend(with: params)
    }
    
    func addressParams(with addressURL: URL) -> AppLinkerAddressWalletParams? {
        let params = parse(addressURL)
        return params
    }
}

private extension AppLinkerAddressWallet {
    
    func parse(_ url: URL) -> AppLinkerAddressWalletParams? {
        guard let addressType = parseAddressForType(url) else {
            return nil
        }
        let keysForParse = parseAddressForKeys(url: url, with: addressType)
        guard let params = parsing(url: url, type: addressType, keys: keysForParse) else {
            return nil
        }
        return params
    }
}

private extension AppLinkerAddressWallet {
    
    func parseAddressForType(_ url: URL) -> LinkerType.WalletAddress? {
        guard let scheme = url.scheme else { return nil }
        if let walletAddressType = LinkerType.WalletAddress(rawValue: scheme) {
            return walletAddressType
        }
        
        return .unknown
    }
    
    func parseAddressForKeys(url: URL, with type: LinkerType.WalletAddress) -> [Params.AppLinkerAddressWalletKeys] {
        var keys = [Params.AppLinkerAddressWalletKeys.address]
        if let theQuery = url.query {
            if theQuery.contains(type.amountKey) {
                keys.append(Params.AppLinkerAddressWalletKeys.amount)
            }
        }

        return keys
    }
    
    func parsing(url: URL, type: LinkerType.WalletAddress, keys: [Params.AppLinkerAddressWalletKeys]) -> AppLinkerAddressWalletParams? {
        switch keys {
            case [Params.AppLinkerAddressWalletKeys.address]:
                if let theAddress = url.host {
                    return makeParams(address: theAddress,
                                      amount: nil,
                                      type: type)
                }
            case [Params.AppLinkerAddressWalletKeys.address, Params.AppLinkerAddressWalletKeys.amount]:
                if let theAddress = url.host {
                    let amount = url[Params.AppLinkerAddressWalletKeys.amount.rawValue]
                    return makeParams(address: theAddress,
                                      amount: amount,
                                      type: type)
                }
            default:
                return nil
        }
        
        return nil
    }
    
    func makeParams(address: String?, amount: String?, comment: String? = nil,
                    contact: String? = nil, type: LinkerType.WalletAddress) -> AppLinkerAddressWalletParams {
        var paramsObject = AppLinkerAddressWalletParams()
        paramsObject.address = address
        paramsObject.amount  = amount
        return paramsObject
    }
}


private extension AppLinkerAddressWallet {
    
    func routeToSend(with params: AppLinkerAddressWalletParams) {
        navigation?.state = .deepLink
        navigation?.addressDeepLinkUserFlow(params: params)
    }
}
