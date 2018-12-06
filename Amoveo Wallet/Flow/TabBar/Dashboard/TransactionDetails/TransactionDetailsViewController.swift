//
// Created by Igor Efremov on 12/07/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

protocol TransactionDetailsActionDelegate: class {
    func showCurrentTxInBlockchain()
    func copyToClipboard(_ value: String?)
}

class TransactionDetailsViewController: UIViewController {
    private let substrateView: UIView = UIView(frame: CGRect.zero)
    private let transactionsView: TransactionDetailsView = TransactionDetailsView(frame: CGRect.zero)
    private var _transaction: Transaction?

    convenience init(_ transaction: Transaction) {
        self.init(nibName: nil, bundle: nil)
        _transaction = transaction
        navigationItem.title = _transaction?.type.description
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addMultipleSubviews(with: [substrateView, transactionsView])
        transactionsView.actionDelegate = self
        transactionsView.viewModel = _transaction

        applyStyles()
        applySizes()
    }

    func applyStyles() {
        view.backgroundColor = UIColor.detailsBackgroundColor
        substrateView.backgroundColor = UIColor.mainColor
        transactionsView.applyStyles()
    }

    func applySizes() {
        substrateView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(270)
        }

        transactionsView.snp.makeConstraints { (make) in
            make.top.left.width.height.equalToSuperview()
        }
        transactionsView.applySizes()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        transactionsView.tableView.contentSize = CGSize(width: view.width, height: max(transactionsView.tableView.height, 540))
    }
}

extension TransactionDetailsViewController: TransactionDetailsActionDelegate {

    func showCurrentTxInBlockchain() {
        guard let theTransaction = _transaction else { return }
        let txUrl = "\(EXAAppInfoService.oldExplorerServiceBaseUrlString)\(theTransaction.txHash)"
        guard let url = URL(string: txUrl) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func copyToClipboard(_ value: String?) {
        guard let theValue = value else { return }
        EXAAppUtils.copy(toClipboard: theValue)
    }
}
