//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class Account {
    private var innerWallet: AmoveoInnerWallet?

    var address: Address {
        return innerWallet?.address ?? ""
    }

    var mnemonicPhrase: String {
        return innerWallet?.mnemonicPhrase ?? ""
    }

    var privateKey: String {
        return innerWallet?.privateKeyInExportFormat() ?? ""
    }

    class func create(wallet: AmoveoInnerWallet) -> Account {
        return Account(wallet: wallet)
    }

    class func create(mnemonic: String) -> Account {
        return Account(mnemonic: mnemonic)
    }

    class func create(privateKey: String) -> Account {
        return Account(privateKey: privateKey)
    }

    class func create() -> Account {
        return Account()
    }

    init(wallet: AmoveoInnerWallet) {
        innerWallet = wallet
    }

    init(mnemonic: String) {
        innerWallet = AmoveoWalletGenerator.create(withMnemonic: mnemonic)
    }

    init(privateKey: String) {
        innerWallet = AmoveoWalletGenerator.create(withPrivateKey: privateKey)
    }

    init() {
        innerWallet = AmoveoWalletGenerator.createWithRandomMnemonic()
    }

    func signDigest(_ digest: Data) -> Signature? {
        return innerWallet?.signDigest(digest)
    }

    func serialize(toDER signature: Signature) -> Data? {
        return innerWallet?.serialize(toDER: signature)
    }

    func encryptSecretStorageJSON(_ password: String, callback: @escaping ((String?) -> Void)) {
        innerWallet?.encryptSecretStorageJSON(password, callback: callback)
    }

    class func decryptSecretStorageJSON(_ json: String, password: String, callback: @escaping ((AmoveoInnerWallet?, Error?) -> Void)) {
        AmoveoInnerWallet.decryptSecretStorageJSON(json, password: password, callback: callback)
    }
}
