//
// Created by Igor Efremov on 27/06/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol TransactionsHistoryActionDelegate: class {
    func onSelectTransaction(_ index: Int)
    func onSelectProposals(_ index: Int)
}

