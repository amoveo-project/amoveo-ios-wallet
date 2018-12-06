//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

typealias TransactionCreationHandler = (PreparedTransactionTemplate) -> ()

final class TransactionCreationService {
    var onPrepared: TransactionCreationHandler?

    private let apiInterface = TransactionCreationInterfaceAPI() as TransactionCreationInterfaceAPIProtocol
    private let dataWorker = TransactionCreationDataWorker()

    func create(_ template: TransactionTemplateBuilder) {

        firstly {
            apiInterface.createTransaction(template)
        }.then { (data: ResponseJSONData) -> Promise<PreparedTransactionTemplate> in
            return self.dataWorker.work(with: data)
        }.done { (transaction) in
            print("<< Got created transaction")
            self.preparedTransaction(transaction)
        }.catch { (error) in
            print("Transaction Creation Service: Error - \(error)")
        }
    }
}

extension TransactionCreationService {
    func preparedTransaction(_ transaction: PreparedTransactionTemplate) {
        onPrepared?(transaction)
    }
}
