//
//  EXAAppUtils.swift
//
//
//  Created by Igor Efremov on 11/03/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SDCAlertView

class EXAAppUtils {
    class func copy(toClipboard address: String, prefixMessage: String? = nil) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = address
        
        let msg: String
        if let thePrefixMessage = prefixMessage {
            msg = "\(thePrefixMessage) \(l10n(.commonCopiedToClipboard))"
        } else {
            msg = l10n(.commonCopiedToClipboard).capitalizedOnlyFirst
        }
        
        let alert = AlertController(title: EXAAppInfoService.appTitle, message: msg, preferredStyle: .alert)
        alert.visualStyle = EXAAlertVisualStyle(alertStyle: .alert)
        alert.present(completion: {
            delay(0.3, closure: {
                alert.dismiss(animated: true)
            })
        })
    }
}
