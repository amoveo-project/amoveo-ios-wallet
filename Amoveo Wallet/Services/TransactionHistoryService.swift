//
// Created by Igor Efremov on 23/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import PromiseKit

typealias TransactionHistoryUpdatedHandler = () -> ()

protocol TransactionHistoryServiceProtocol {

    var onUpdate: TransactionHistoryUpdatedHandler? { get set }
    func update()
}

final class TransactionHistoryService {

    var onUpdate: TransactionHistoryUpdatedHandler?

    private let apiInterface = ExplorerInterfaceAPI() as ExplorerInterfaceAPIProtocol
    private let dataWorker = TransactionsDataWorker()
    private let group = DispatchGroup()

    private var walletInfo: OpenWalletInfo? {
        get { return AppState.sharedInstance.walletInfo }
    }
}

extension TransactionHistoryService: TransactionHistoryServiceProtocol {

    func update() {

        fetchVEOTransactions()
        subscriptForFinishedFetching()
    }
}

private extension TransactionHistoryService {

    func fetchVEOTransactions() {
        //group.enter()
        print("Fetch VEO transaction history")
        group.enter()

        if let address = AppState.sharedInstance.walletInfo?.address {
            firstly {
                apiInterface.getTransactionList(address)
            }.then { (contentData: ResponseRawData) -> Promise<[CommonTransaction]> in
                return self.dataWorker.work(with: contentData)
            }.done { (transactionsList) in
                print("<< Got Content \(transactionsList)")
                self.addVEOTransactions(transactionsList)
                //noop()
                self.group.leave()
            }.catch { (error) in
                print("transactions Service: Error - \(error)")
                self.group.leave()
            }
        }
    }

    func subscriptForFinishedFetching() {
        group.notify(queue: .global()) {
            self.onUpdate?()
        }
    }

    func addVEOTransactions(_ transactions: [CommonTransaction]?) {
        if let veoTransactions = transactions, veoTransactions.count != 0 {
            for item in veoTransactions {
                walletInfo?.transactionDictionaryHistory[item.uuid] = item
            }
        }
    }
}
