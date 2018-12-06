//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

typealias TransactionSendingHandler = (String) -> ()

final class TransactionSendingService {
    var onSent: TransactionSendingHandler?

    private let apiInterface = TransactionSenderInterfaceAPI() as TransactionSenderInterfaceAPIProtocol
    private let dataWorker = TransactionSendingDataWorker()

    func send(_ signedTx: SignedTransactionSerializer) {

        firstly {
            apiInterface.sendTransaction(signedTx)
        }.then { (data: ResponseJSONData) -> Promise<String> in
            return self.dataWorker.work(with: data)
        }.done { (txHash) in
            self.serviceDidSend(txHash)
        }.catch { (error) in
            print("Transaction Sending Service: Error - \(error)")
            DispatchQueue.main.async {
                EXADialogs.showError(error)
            }
        }
    }
}

extension TransactionSendingService {
    func serviceDidSend(_ txHash: String) {
        DispatchQueue.main.async { [weak self] in
            self?.onSent?(txHash)
        }
    }
}
