//
//  UIGeometryUtil.swift
//
//  Created by Igor Efremov on 05/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

class UIGeometryUtil {
    static func center(of rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
}
