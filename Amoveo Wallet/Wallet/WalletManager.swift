//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class WalletManager: WalletManagerProtocol {
    func encryptWallet(_ pass: String, account: Account, callback: @escaping ((String?) -> Void)) {
        account.encryptSecretStorageJSON(pass, callback: callback)
    }

    func decryptWallet(_ pass: String, accessGranted: ((Account) -> Swift.Void)? = nil, accessDenied: (() -> (Swift.Void))? = nil) {
        if let theDocumentsDirectory = EXACommon.documentsDirectory {
            let walletFilePath = theDocumentsDirectory.appendPathComponent(AWConfiguration.shared.encryptedWalletFileName)
            if FileManager.default.fileExists(atPath: walletFilePath) {
                if let data: Data = try? Data(contentsOf: URL(fileURLWithPath: walletFilePath)) {
                    let jsonWallet = String(data: data, encoding: .utf8)!
                    Account.decryptSecretStorageJSON(jsonWallet, password: pass, callback: {
                        (innerWallet: AmoveoInnerWallet?, error: Error?) in
                        if let theInnerWallet = innerWallet {
                            accessGranted?(Account.create(wallet: theInnerWallet))
                        } else {
                            accessDenied?()
                        }
                    })
                } else {
                    print("Load wallet FAILED!")
                    accessDenied?()
                }
            } else {
                accessDenied?()
            }
        }
    }
}
