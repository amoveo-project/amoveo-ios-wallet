//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum AWFontType {
    case regular, medium, bold

    var fontName: String {
        switch self {
        case .regular:
            return "Ubuntu"
        case .medium:
            return "Ubuntu-Medium"
        case .bold:
            return "Ubuntu-Bold"
        }
    }
}

extension UIFont {

    class func awFont(ofSize fontSize: CGFloat, type: AWFontType) -> UIFont {
        return UIFont(name: type.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    static func specialFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "ShareTechMono-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
