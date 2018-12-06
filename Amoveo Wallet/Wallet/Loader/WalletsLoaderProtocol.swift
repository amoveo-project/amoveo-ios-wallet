//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol WalletsLoaderProtocol {
    func load(handlerOnOpen: @escaping (OpenWalletInfo?) ->())
    func save()
}
