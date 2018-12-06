//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

typealias BalanceUpdatedHandler = () -> ()

protocol BalanceServiceProtocol {

    var onUpdate: BalanceUpdatedHandler? { get set }
    func update()
    func update(_ type: WalletType)
}