//
// Created by Igor Efremov on 26/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

typealias CrossRateUpdatedHandler = () -> ()
typealias CrossRateUpdatedValueHandler = (Double) -> ()

protocol CrossRateServiceProtocol {

    var onUpdate: CrossRateUpdatedHandler? { get set }
    var onUpdateValue: CrossRateUpdatedValueHandler? { get set }
    func update()
}
