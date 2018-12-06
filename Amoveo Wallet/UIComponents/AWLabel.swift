//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum LabelPalette {

    case main
    case title
    case darkMain
    case address
    case other

    var font: UIFont {
        switch self {
        case .main:
            return UIFont.awFont(ofSize: 14.0, type: .regular)
        case .title:
            return UIFont.systemFont(ofSize: 12.0)
        case .address:
            return UIFont.systemFont(ofSize: 18.0)
        case .darkMain:
            return UIFont.systemFont(ofSize: 14.0)
        case .other:
            return UIFont.systemFont(ofSize: 17.0)
        }
    }

    var textColor: UIColor {
        switch self {
        case .main:
            return UIColor.mainColor
        case .title, .address:
            return UIColor.titleLabelColor
        case .darkMain:
            return UIColor.black
        case .other:
            return UIColor.black
        }
    }

    var alignment: NSTextAlignment? {
        switch self {
        case .main, .title, .address, .darkMain, .other:
            return nil
        }
    }
}

final class AWLabel: UILabel {

    var style: LabelPalette = .other {
        didSet {
            font = style.font
            textColor = style.textColor

            if let alignment = style.alignment {
                textAlignment = alignment
            }
        }
    }
}