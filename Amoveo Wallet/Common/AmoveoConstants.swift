//
// Created by Igor Efremov on 22/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

struct AmoveoConstants {
    static let fabricApiKeyPath = "fabric.apikey"
    static let crossRateApiKeyPath = "crossrate.apikey"
    static let encryptedWalletFile = "encrypted_wallet.json"
#if TEST
    static let projectTestDataPath = "Projects/Exantech/Gitlab/amoveo-ios-wallet/testData"
    static let testPrivateKeyFile = "test_pk.txt"
    static let testCreateAccTransaction = "test_create_acc_transaction.txt"
    static let testReceiveAddress = "test_receive_address.txt"
#endif
}
