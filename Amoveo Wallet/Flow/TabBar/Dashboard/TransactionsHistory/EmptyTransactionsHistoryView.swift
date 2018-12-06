//
// Created by Igor Efremov on 27/06/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit

protocol EmptyTransactionsHistoryViewActionDelegate: class {
    func onRequestSomeMoney()
}

class EmptyTransactionsHistoryView: UITableView {
    weak var actionDelegate: EmptyTransactionsHistoryViewActionDelegate?

    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension EmptyTransactionsHistoryView {
    static let defaultHeaderHeight: CGFloat = 60.0

    func setup() {
        backgroundColor = .white
        dataSource = self
        delegate = self

        super.applyStyles()
        self.separatorColor = UIColor.clear
        self.separatorStyle = .none
    }
}

extension EmptyTransactionsHistoryView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            actionDelegate?.onRequestSomeMoney()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EmptyTransactionsHistoryView.defaultHeaderHeight
    }
}

extension EmptyTransactionsHistoryView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = "Request some VEO" // TODO
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.awFont(ofSize: 18.0, type: .bold)
        cell.textLabel?.textColor = UIColor.mainColor

        return cell
    }
}
