//
// Created by Igor Efremov on 17/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class EXAAppNavigationDispatcher {
    static let sharedInstance = EXAAppNavigationDispatcher()
    weak var actionDelegate: EXAAppNavigationDelegate?

    func resetWalletAndStartNew() {
        self.actionDelegate?.resetWalletAndStartNew()
    }

    func showWalletAfterCreate(_ isRestored: Bool = false) {
        self.actionDelegate?.showWalletAfterCreate(isRestored)
    }
}
