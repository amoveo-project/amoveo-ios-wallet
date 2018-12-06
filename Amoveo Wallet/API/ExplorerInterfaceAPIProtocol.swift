//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

protocol ExplorerInterfaceAPIProtocol {

    func getTransactionList(_ address: String) -> Promise<ResponseRawData>
}
