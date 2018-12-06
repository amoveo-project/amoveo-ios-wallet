//
//  DashboardViewController.swift
//
//
//  Created by Igor Efremov on 09/01/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

typealias TransactionIndex = Int
typealias TransactionSelectedCallback = (TransactionIndex) -> ()

protocol EXAHistoryViewActionDelegate: class {
    func requestTransactionsList(_ force: Bool)
    func updateTransactionsList()
    func showTransaction(_ index: Int)
}

enum DashboardViewLayerState {
    case balance, transactions
}

protocol DashboardViewProtocol {
    
    var onWillAppear: DefaultCallback? { get set }
    var onWillDisappear: DefaultCallback? { get set }
    var onDidLoad: DefaultCallback? { get set }
    
    var onBalanceBillSelected: BalanceBillSelectedHandler? { get set }
    var onBalanceSelected: DefaultCallback? { get set }
    var onBalanceUpdate: DefaultCallback? { get set }
    var onTransactionListSelected: DefaultCallback? { get set }
    var onExchangeSelected: DefaultCallback? { get set }
    var onTransactionSelected: TransactionSelectedCallback? { get set }
    var onGetLocalTransactions: DefaultCallback? { get set }

    var onRequestVEO: DefaultCallback? { get set }
    
    func updateTransactionsList(with model: TransactionViewModel)
    func updateBalance(_ balances: [Balance])
    func updateTransactions(_ rule: TransactionUpdateRule)
    func updateCrossRate(_ value: Double, ticker: String)
    func showMessage(with title: String, message: String, buttonTitle: String)
}

final class DashboardViewLayer: CommonViewLayer {

    var onWillAppear: DefaultCallback?
    var onWillDisappear: DefaultCallback?
    var onDidLoad: DefaultCallback?
    
    var onBalanceBillSelected: BalanceBillSelectedHandler?
    var onTransactionSelected: TransactionSelectedCallback?
    var onBalanceSelected: DefaultCallback?
    var onBalanceUpdate: DefaultCallback?
    var onTransactionListSelected: DefaultCallback?
    var onExchangeSelected: DefaultCallback?
    var onGetLocalTransactions: DefaultCallback?

    var onRequestVEO: DefaultCallback?
    
    private let containerView = DashboardView()
    
    override func loadView() {
        super.loadView()
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDidLoad?()
        subscriptForViewEvents()
        subscriptForSegmentControlEvents()
        setupBackButton()
        setupActionDelegate()

        self.navigationItem.title = l10n(.tabDashboardTitle)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onWillAppear?()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onWillDisappear?()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension DashboardViewLayer: DashboardViewProtocol {

    func updateBalance(_ balances: [Balance]) {
        containerView.dashboardTableView.update(with: balances)
    }
    
    func updateTransactions(_ updateRule: TransactionUpdateRule) {
        switch updateRule {
        case .getfromLocal:
            onGetLocalTransactions?()
        case .updateUI:
            containerView.dashboardTableView.updateUI()
            // TODO
            noop()
        }
    }

    func updateCrossRate(_ value: Double, ticker: String) {
        containerView.dashboardTableView.updateCrossRate(value, ticker: ticker)
    }
    
    func updateTransactionsList(with model: TransactionViewModel) {
        containerView.dashboardTableView.updateTransactions(with: model)
        containerView.historyView.isHidden = !model.isEmpty()
    }
    
    func showMessage(with title: String, message: String, buttonTitle: String) {
        EXADialogs.showMessage(message, title: title,
                                     buttonTitle: buttonTitle)
    }
}

private extension DashboardViewLayer {
    
    func subscriptForSegmentControlEvents() {
        containerView.onBalanceSelected = { [weak self] in
            self?.selectBalance()
        }
    }
    
    func selectBalance() {
        onBalanceSelected?()
        assemblyView(with: .balance)
    }
    
    func assemblyView(with state: DashboardViewLayerState) {
        switch state {
        case .balance:
            hiddenSubviews(with: false)
        case .transactions:
            hiddenSubviews(with: true)
        }
    }
    
    func hiddenSubviews(with value: Bool) {
        let subviews = [containerView.dashboardTableView]
        _ = subviews.map{$0.isHidden = value}
        //containerView.historyView.isHidden = !value
        // TODO
        noop()
    }
}

private extension DashboardViewLayer {
    
    func subscriptForViewEvents() {
        containerView.onExchangeTapped = onExchangeSelected
        containerView.onUpdateSelected = onBalanceUpdate
        containerView.onBalanceBillSelected = { [weak self] bill in
            self?.onBalanceBillSelected?(bill)
        }

        containerView.onRequestVEO = { [weak self] in
            self?.onRequestVEO?()
        }
    }
}

extension DashboardViewLayer: EXAHistoryViewActionDelegate {
    
    func setupActionDelegate() {
        containerView.dashboardTableView.actionDelegate = self
    }
    
    func requestTransactionsList(_ force: Bool = false) {
        onTransactionListSelected?()
    }
    
    func updateTransactionsList() {
        onGetLocalTransactions?()
        //containerView.historyView.updateUI()
        // TODO
        noop()
    }
    
    func showTransaction(_ index: Int) {
        onTransactionSelected?(index)
    }
}


