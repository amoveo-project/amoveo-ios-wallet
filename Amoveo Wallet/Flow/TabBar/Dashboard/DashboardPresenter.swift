//
//  DashboardPresenter.swift
//
//  Created by Vladimir Malakhov on 13/06/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol DashboardPresenterProtocol {
    func start()
}

final class DashboardPresenter {
    
    var viewLayer: DashboardViewProtocol?
    var interactor: DashboardInteractorProtocol?
    var navigation: AppNavigationProtocol?
}

extension DashboardPresenter: DashboardPresenterProtocol {
    
    func start() {
        subscriptForViewEvents()
        subscriptForInteractorEvents()
    }
}

private extension DashboardPresenter {
    
    func subscriptForViewEvents() {
        
        viewLayer?.onDidLoad = updateBalanceByLocalData
        viewLayer?.onWillAppear = moduleStartRequestData
        viewLayer?.onWillDisappear = moduleStopRequestData
        
        viewLayer?.onBalanceSelected = updateBalance
        viewLayer?.onTransactionListSelected = updateTransactions
        viewLayer?.onGetLocalTransactions = loadTransactionViewModel

        viewLayer?.onTransactionSelected = routeToTransactionFlow
        viewLayer?.onBalanceBillSelected = onBillSelected

        viewLayer?.onRequestVEO = onRequestVEO
    }
    
    func moduleStartRequestData() {
        //AppState.sharedInstance.walletInfo?.transactionHistory = [CommonTransaction]()
        interactor?.fetchTransactions(true)
        interactor?.fetchBalance()
        interactor?.fetchCrossRate()
        interactor?.startFetchingTransactions()
    }
    
    func moduleStopRequestData() {
        interactor?.stopFetchingTransactions()
    }
    
    func updateBalance() {
        interactor?.fetchBalance()
    }
    
    func updateTransactions() {
        interactor?.fetchTransactions(true)
    }
    
    func loadTransactionViewModel() {
        let transactionVM = TransactionViewModel()
        transactionVM.load()
        viewLayer?.updateTransactionsList(with: transactionVM)
    }
    
    func updateBalanceByLocalData() {
        // TODO: Uncomment
        /*interactor?.updateBalanceFromLocalWallet(balance: { [weak self] (balance) in
            self?.viewLayer?.updateBalance(balance)
            self?.viewLayer?.updateTransactionsList(with: <#T##TransactionViewModel##Amoveo_Wallet.TransactionViewModel#>)
        })*/

        //loadTransactionViewModel()
    }
}

private extension DashboardPresenter {

    func routeToTransactionFlow(_ index: TransactionIndex) {
        guard let list = interactor?.getTransactionList(), list.count >= index else {
            return
        }
        let info = list[index]
        navigation?.presentSingleFrame(for: .transactionInfo, data: info)
    }
}

private extension DashboardPresenter {
    
    func subscriptForInteractorEvents() {
        interactor?.onTransactionsUpdated = viewLayer?.updateTransactions
        interactor?.onAllBalancesUpdated = viewLayer?.updateBalance
        interactor?.onCrossRateUpdated = viewLayer?.updateCrossRate
    }
}

private extension DashboardPresenter {
    
    func onBillSelected(_ bill: CryptoTicker) {
        switch bill {
        case .VEO:
            break
        }
    }

    func onRequestVEO() {
        navigation?.presentSingleTab(for: .receive, with: nil as NavigationData?)
    }
}
