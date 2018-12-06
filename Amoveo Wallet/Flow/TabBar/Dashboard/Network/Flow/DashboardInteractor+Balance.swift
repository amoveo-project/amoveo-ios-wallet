//
//  DashboardInteractor+Balance.swift
//
//  Created by Igor Efremov on 18/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

extension DashboardInteractor {
    
    private var balanceStorage: BalanceStorageProtocol? {
        get { return AppState.sharedInstance.walletInfo?.balance }
    }
    
    func updateBalance() {
        var service = BalanceService() as  BalanceServiceProtocol
        service.onUpdate = { [weak self] in
            self?.onAllBalancesUpdated?([Balance(value: self?.balanceStorage?.getBalance(ticker: .VEO), type: .VEO)])
        }

        service.update()
    }
    
    func updateBalanceFromLocalWallet(balance: @escaping BalanceUpdatedCallback) {
        let balanceVEO = Balance(value: balanceStorage?.getBalance(ticker: .VEO), type: .VEO)
        guard let amountVEO = balanceVEO.value, amountVEO >= Double.ulpOfOne else {
                fetchBalance()
                return
        }
        
        balance([balanceVEO])
    }
}
