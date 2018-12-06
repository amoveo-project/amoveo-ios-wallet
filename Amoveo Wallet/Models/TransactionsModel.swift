//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class TransactionsModel {
    private var items: [CommonTransaction]?

    func load(_ walletInfo: OpenWalletInfoProtocol?) {
        print("Load VEO transactions")
        items = [CommonTransaction]()

        if let theWalletInfo = walletInfo {
            for item: CommonTransaction in theWalletInfo.transactionDictionaryHistory.values {
                items?.append(item)
            }
        }

        items = items?.sorted {$0.timestamp > $1.timestamp }
    }

    func loadVEOTransactions() {

    }

    func add(_ transaction: CommonTransaction) {
        items?.append(transaction)
    }

    func addList(_ transactions: [CommonTransaction]) {
        transactions.forEach { (transaction) in
            add(transaction)
        }
    }

    func item(_ index: Int) -> CommonTransaction? {
        guard let items = items else { return nil}
        guard index < items.count else {
            return nil
        }

        return items[index]
    }

    func sort() {
    }

    func clear() {

    }

    func listOfTransactions() -> [CommonTransaction]? {
        return items
    }

    func mockLoad() {
        // TODO
        print("LOAD mock transactions")
        //items = FakeTransactionsHistoryList.items
    }
}
