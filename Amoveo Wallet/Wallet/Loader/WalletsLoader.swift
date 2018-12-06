//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class WalletsLoader: WalletsLoaderProtocol {
    func load(handlerOnOpen: @escaping (OpenWalletInfo?) ->()) {
        if let theAddress = UserDefaults.standard.string(forKey: "amoveoAddress") {
            let walletInfo = OpenWalletInfo(address: theAddress)
            handlerOnOpen(walletInfo)
        } else {
            handlerOnOpen(nil)
        }
    }

    func save() {
        UserDefaults.standard.set(AppState.sharedInstance.walletInfo?.address, forKey: "amoveoAddress")
    }
}
