//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

typealias SelectTransactionTypeHandler = (TransactionBlockchainType) -> ()

final class SelectTransactionTypeService {
    var onSelectedType: SelectTransactionTypeHandler?

    private let apiInterface = SelectTransactionTypeAPI() as SelectTransactionTypeAPIProtocol
    private let dataWorker = SelectTransactionTypeDataWorker()

    func select(_ address: AddressSerializer) {

        firstly {
            apiInterface.selectTransactionType(address)
        }.then { (data: ResponseJSONData) -> Promise<TransactionBlockchainType> in
            return self.dataWorker.work(with: data)
        }.done { (transactionType) in
            print("<< Got created transaction")
            self.serviceDidComplete(transactionType)
        }.catch { (error) in
            print("Transaction Type Selection Service: Error - \(error)")
        }
    }
}

extension SelectTransactionTypeService {
    func serviceDidComplete(_ transactionType: TransactionBlockchainType) {
        onSelectedType?(transactionType)
    }
}
