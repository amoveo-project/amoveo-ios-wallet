//
//  DashboardTableView.swift
//
//  Created by Igor Efremov on 19/04/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

private enum Section: Int {
    case balance, history
}

private struct Constants {
    
    static let cellBalanceHeight: CGFloat = 60.0
    
    var cellTransHeight: CGFloat {
        get {
            if DeviceType.isiPhoneX {
                return 190
            } else if DeviceType.isiPhone5 {
                return 110
            } else {
                return 150
            }
        }
    }

    static let balanceTableViewCellReuseId = "BalanceTableViewCellIdentifier"
}

final class TransactionsHistoryTableView: UITableView {

    var onBalanceBillSelected: ((CryptoTicker) -> ())?
    var onTransactionSelected: DefaultCallback?
    
    private(set) var balanceList = [Balance(value: nil, type: .VEO)]
    private var transactionsViewModel: TransactionViewModel?
    private var hv: AmountHeaderView?

    weak var actionDelegate: EXAHistoryViewActionDelegate?
    
    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with balanceList: [Balance]) {
        self.balanceList = balanceList
        reloadData()
    }

    func updateTransactions(with vm: TransactionViewModel?) {
        self.transactionsViewModel = vm
        reloadData()
    }

    func updateUI() {

        print("updateUI")
    }

    func updateCrossRate(_ value: Double, ticker: String) {
        if let currentBalance: Balance = balanceList.first {
            let amoveoBalance = currentBalance.value ?? AmountValue(0.0)
            let currency = AppState.sharedInstance.settings.selectedCurrency

            hv?.infoLabel.text = EXAWalletFormatter.alternativeAmount(type: AppState.sharedInstance.settings.showInDashboard, currency: currency, amount: amoveoBalance, rateValue: value)
        }
    }
}

private extension TransactionsHistoryTableView {
    
    func setup() {
        setupDelegates()
        registerCell()

        self.backgroundColor = UIColor.clear
    }
    
    func setupDelegates() {
        dataSource = self
        delegate = self
    }
    
    func registerCell() {
        register(BalanceTableViewCell.self, forCellReuseIdentifier: Constants.balanceTableViewCellReuseId)
    }
}

extension TransactionsHistoryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.balance.rawValue:
            return Constants.cellBalanceHeight
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionDelegate?.showTransaction(indexPath.row)
    }
}

extension TransactionsHistoryTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.balance.rawValue:
            return 0
        case Section.history.rawValue:
             return transactionsViewModel?.model?.listOfTransactions()?.count ?? 0
        default:
            return 0
        }
    }

    private func preparedDestination(_ tx: CommonTransaction) -> String {
        let partAddressLength = 14
        let value = transactionType(tx) == .sent ? tx.to : tx.from
        if value.length > 2 * partAddressLength + 1 {
            let startPart = value.index(value.startIndex, offsetBy: partAddressLength)
            let endPart = value.index(value.startIndex, offsetBy: value.length - partAddressLength)
            return value.prefix(upTo: startPart) + "..." + value.suffix(from: endPart)
        } else {
            return value + "..."
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.balance.rawValue:
            return UITableViewCell()
        case Section.history.rawValue:
            if let theItem = transactionsViewModel?.model?.item(indexPath.row) {
                let tx = Transaction(theItem.uuid, NSDecimalNumber(string: theItem.amount, locale: NSLocale.current), rawDate: theItem.date, transactionType(theItem))
                tx.destination = preparedDestination(theItem)
                tx.pending = theItem.pending
                let cell = TransactionViewCell(transaction: tx)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case Section.balance.rawValue:
            return 122.0
        default:
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var amoveoBalance: AmountValue
        if let currentBalance: Balance = balanceList.first ?? nil {
            amoveoBalance = currentBalance.value ?? AmountValue(0.0)
        } else {
            amoveoBalance = AmountValue(0.0)
        }

        hv = AmountHeaderView(width: tableView.bounds.size.width, title: amoveoBalance.toVEOString() + " " + CryptoTicker.VEO.description,
                color: UIColor.headerColor, textColor: UIColor.awYellow)

        let currency = AppState.sharedInstance.settings.selectedCurrency
        if let rateValue = AppState.sharedInstance.currentRate {
            hv?.infoLabel.text = EXAWalletFormatter.alternativeAmount(type: AppState.sharedInstance.settings.showInDashboard, currency: currency, amount: amoveoBalance, rateValue: rateValue)
        }
        hv?.applyLayout()

        return hv
    }

    private func transactionType(_ transaction: CommonTransaction) -> TransactionType {
        guard let address = AppState.sharedInstance.walletInfo?.address else { return .received } // TODO: Rewrite !!!
        if address.hasPrefix(transaction.from) {
            return .sent
        } else {
            return .received
        }
    }
}

private extension TransactionsHistoryTableView {
    
    func makeBalanceCell(indexPath: IndexPath) -> BalanceTableViewCell? {
        guard let balanceCell = dequeueReusableCell(withIdentifier: Constants.balanceTableViewCellReuseId, for: indexPath) as? BalanceTableViewCell else {
            return nil
        }
        let currentBalance = balanceList[indexPath.row]
        balanceCell.update(with: currentBalance)
        
        return balanceCell
    }
}
