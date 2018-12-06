//
// Created by Igor Efremov on 17/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum AppSingleFrameType {
    case main, about, walletPassphrase, restoreWallet, createPassword, transactionInfo
}

enum AppTabFrameType: Int {
    case receive, send, dashboard, settings

    var title: String {
        return ""
    }

    var icon: UIImage? {
        switch self {
        case .receive:
            return EXAGraphicsResources.receiveTab
        case .send:
            return EXAGraphicsResources.sendTab
        case .dashboard:
            return EXAGraphicsResources.dashboardTab
        case .settings:
            return EXAGraphicsResources.settingsTab
        }
    }

    var position: Int {
        return self.rawValue
    }
}
