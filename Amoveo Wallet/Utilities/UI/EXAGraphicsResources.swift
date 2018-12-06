//
//  EXAGraphicsResources.swift
//
//  Created by Igor Efremov on 02/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class EXAGraphicsResources {
    static var copy: UIImage {
        return #imageLiteral(resourceName: "copy")
    }

    static var copySmall: UIImage {
        return #imageLiteral(resourceName: "copy_small")
    }

    static var create: UIImage {
        return #imageLiteral(resourceName: "create")
    }

    static var restore: UIImage {
        return #imageLiteral(resourceName: "restore")
    }

    static var share: UIImage {
        return #imageLiteral(resourceName: "share")
    }

    static var homeTab: UIImage {
        return #imageLiteral(resourceName: "home_tab")
    }

    static var receiveTab: UIImage {
        return #imageLiteral(resourceName: "receive")
    }

    static var sendTab: UIImage {
        return #imageLiteral(resourceName: "send")
    }

    static var dashboardTab: UIImage {
        return #imageLiteral(resourceName: "dashboard")
    }

    static var walletSettingsTab: UIImage {
        return #imageLiteral(resourceName: "wallet_settings_tab")
    }

    static var settingsTab: UIImage {
        return #imageLiteral(resourceName: "settings")
    }

    static var validationSuccess: UIImage {
        return #imageLiteral(resourceName: "validation_success")
    }

    static var editMeta: UIImage {
        return #imageLiteral(resourceName: "edit_meta")
    }

    static var delete: UIImage {
        return #imageLiteral(resourceName: "delete")
    }

    static var remember: UIImage {
        return #imageLiteral(resourceName: "remember")
    }
    
    static var error: UIImage {
        return #imageLiteral(resourceName: "error_sign")
    }
    
    static var logo: UIImage {
        return #imageLiteral(resourceName: "logo")
    }

    static var logoPin: UIImage {
        return #imageLiteral(resourceName: "logo_pin")
    }
    
    static var close: UIImage {
        return #imageLiteral(resourceName: "close")
    }

    static var qr: UIImage {
        return #imageLiteral(resourceName: "qr")
    }

    static var btnArrow: UIImage {
        return #imageLiteral(resourceName: "btn_arrow")
    }

    static var optionArrow: UIImage {
        return #imageLiteral(resourceName: "option_arrow")
    }

    static var downArrow: UIImage {
        return #imageLiteral(resourceName: "down_arrow")
    }

    static var logoImage: UIImage {
        return #imageLiteral(resourceName: "splash_screen")
    }
    
    static var telegram: UIImage {
        return #imageLiteral(resourceName: "telegram")
    }

    static func transactionType(_ type: TransactionType) -> UIImage {
        let resource: String
        switch type {
        case .sent:
            resource = "sent_tx"
        case .received:
            resource = "received_tx"
        }

        return #imageLiteral(resourceName: resource)
    }

    static var loaderImage: UIImage {
        return #imageLiteral(resourceName: "logo_loader")
    }

    static var proposalInProcess: UIImage {
        return #imageLiteral(resourceName: "proposal_process")
    }

    static var addImage: UIImage {
        return #imageLiteral(resourceName: "add")
    }

    static var personalWalletImage: UIImage {
        return UIImage(named: "personal_wallet.png")!
    }

    static var commonWalletImage: UIImage {
        return UIImage(named: "common_wallet.png")!
    }
}
