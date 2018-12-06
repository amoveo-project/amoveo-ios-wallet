//
//  TransactionViewModel.swift
//
//  Created by Igor Efremov on 05/02/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class TransactionViewModel {
    private var _model: TransactionsModel? = AppState.sharedInstance.walletInfo?.transactionsModel
    var model: TransactionsModel? {
        get {
            return _model
        }
    }

    init() {
        print("TransactionViewModel INIT")
    }
    
    func load() {
        _model?.load(AppState.sharedInstance.walletInfo)
        _model?.loadVEOTransactions()
        _model?.sort()
    }
    
    func clear() {
        _model?.clear()
    }
    
    func mockLoad() {
        _model?.mockLoad()
    }
    
    func isEmpty() -> Bool {
        guard let items = _model?.listOfTransactions() else { return true }
        return items.count == 0
    }
}
