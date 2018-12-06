//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol WalletProtocol {
    var address: Address? { get set }
    var account: Account { get set }
    var name: String { get set }
    var type: WalletType { get set }
}
