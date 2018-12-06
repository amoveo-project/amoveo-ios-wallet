//
//  DashboardView.swift
//
//
//  Created by Igor Efremov on 13/06/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit
import CRRefresh

typealias BalanceBillSelectedHandler = ((CryptoTicker) -> ())

final class DashboardView: CommonView {
    
    var onUnconfirmedSelected: DefaultCallback?
    var onBalanceBillSelected: BalanceBillSelectedHandler?
    var onUpdateSelected: DefaultCallback?
    var onExchangeTapped: DefaultCallback?
    var onBalanceSelected: DefaultCallback?
    var onTransactionSelected: DefaultCallback?
    var onRequestVEO: DefaultCallback?

    private let substrateView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor.mainColor
        return v
    }()
    
    let dashboardTableView: TransactionsHistoryTableView = {
        let dashboard = TransactionsHistoryTableView()
        dashboard.separatorStyle = .none
        return dashboard
    }()
    
    let historyView: EmptyTransactionsHistoryView = {
        let history = EmptyTransactionsHistoryView()
        history.isHidden = true
        return history
    }()
    
    override init() {
        super.init()
        addSubviews()
        setupConstraints()
        setupActions()

        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DashboardView {
    
    func addSubviews() {
        addMultipleSubviews(with: [substrateView, dashboardTableView, historyView])
    }
    
    func setupConstraints() {

        substrateView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(170)
        }

        dashboardTableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalToSuperview()
        }

        historyView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10 + 122)
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }
}

private extension DashboardView {
    
    func setupActions() {
        balanceAction()
    }
    
    func balanceAction() {
        dashboardTableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            self?.onUpdateSelected?()
            self?.animatePull()
        }
        dashboardTableView.onBalanceBillSelected = { [weak self] bill in
            self?.onBalanceBillSelected?(bill)
        }

        historyView.actionDelegate = self
    }
}

private extension DashboardView {
    
    func animatePull() {
        let uploadTimeLine = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + uploadTimeLine, execute: { [weak self] in
            self?.dashboardTableView.cr.endHeaderRefresh()
        })
    }
}

extension DashboardView: EmptyTransactionsHistoryViewActionDelegate {

    func onRequestSomeMoney() {
        self.onRequestVEO?()
    }
}
