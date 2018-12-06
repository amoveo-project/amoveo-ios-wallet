//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class AccountFabric {

    func createAccount() -> Account {
        return Account.create()
    }
}
