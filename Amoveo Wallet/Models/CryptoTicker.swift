//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum CryptoTicker: Int, Codable {
    case VEO = 0

    var description: String {
        switch self {
        case .VEO: return "VEO"
        }
    }

    var title: String {
        switch self {
        case .VEO: return "Amoveo"
        }
    }

    var image: UIImage {
        switch self {
        case .VEO:
            guard let image = UIImage(named: "logo.png") else {
                return UIImage()
            }
            return image
        }
    }
}
