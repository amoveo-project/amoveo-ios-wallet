//
//  WalletOptionViewType.swift
//
//  Created by Igor Efremov on 05/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum WalletOptionViewType {
    
    case create
    case restore
    
    var title: String {
        switch self {
        case .create:
            return l10n(.walletOptionCreate)
        case .restore:
            return l10n(.walletOptionRestore)
        }
    }
    
    var icon: UIImage {
        switch self {
        case .create:
            return EXAGraphicsResources.create
        case .restore:
            return EXAGraphicsResources.restore
        }
    }
}
