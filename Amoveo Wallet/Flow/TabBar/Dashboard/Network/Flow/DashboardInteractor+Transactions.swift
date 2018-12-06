//
//  DashboardInteractor+Transactions.swift
//
//
//  Created by Igor Efremov on 18/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

extension DashboardInteractor {
    
    func updateTransactionHistory() {
        var service = TransactionHistoryService() as TransactionHistoryServiceProtocol
        service.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.onTransactionsUpdated?(.getfromLocal)
            }
        }

        service.update()
    }

    func updatePendingTransactions() {
        let service = PendingTransactionsInfoService()
        service.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.onTransactionsUpdated?(.getfromLocal)
            }
        }

        service.update()
    }
}
