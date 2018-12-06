//
//  AppFrame.swift
//
//  Created by Igor Efremov on 05/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

final class AppFrame {
    
    var viewLayer: ViewLayer

    init(viewLayer: ViewLayer) {
        self.viewLayer = viewLayer
    }
}

final class SingleFrameViewLayer: CommonViewLayer {
    var navigation: AppNavigationProtocol?
}

final class AppWireframe: AppWireframeProtocol {

    var navigation: AppNavigationProtocol?

    func constructTabFrame(for type: AppTabFrameType) -> AppFrame {
        switch type {
        case .receive:
            return receiveFrame()
        case .send:
            return sendFrame()
        case .dashboard:
            return dashboardFrame()
        case .settings:
            return settingFrame()
        }
    }

    func constructSingleFrame<T>(for type: AppSingleFrameType, data: T?) -> AppFrame {
        switch type {
        case .main:
            return newWalletFrame()
        case .about:
            return aboutFrame()
        case .walletPassphrase:
            return walletPassphraseFrame()
        case .restoreWallet:
            return restoreWalletFrame()
        case .createPassword:
            return createPasswordFrame()
        case .transactionInfo:
            return transactionInfoFrame(data)
        }
    }
}

private extension AppWireframe {

    func receiveFrame() -> AppFrame {
        let presenter = ReceivePresenter()
        let viewLayer = ReceiveViewController()
        presenter.viewLayer = viewLayer
        presenter.start()
        return AppFrame(viewLayer: viewLayer)
    }

    func sendFrame() -> AppFrame {
        let viewLayer = SendViewController()
        return AppFrame(viewLayer: viewLayer)
    }

    func dashboardFrame() -> AppFrame {
        let presenter  = DashboardPresenter()
        let interactor = DashboardInteractor()
        let viewLayer  = DashboardViewLayer()
        presenter.navigation = navigation
        presenter.interactor = interactor
        presenter.viewLayer  = viewLayer
        presenter.start()
        return AppFrame(viewLayer: viewLayer)
    }

    func settingFrame() -> AppFrame {
        let presenter  = SettingsPresenter()
        let viewLayer = SettingsViewController()
        presenter.navigation = navigation
        presenter.viewLayer  = viewLayer
        presenter.start()
        return AppFrame(viewLayer: viewLayer)
    }

    func newWalletFrame() -> AppFrame {
        let vc = MainViewController()
        let viewLayer = vc.wrapWithNavigation()
        return AppFrame(viewLayer: viewLayer)
    }

    func aboutFrame() -> AppFrame {
        let vc = AboutViewController()
        let viewLayer = vc.wrapWithNavigation()
        return AppFrame(viewLayer: viewLayer)
    }

    func walletPassphraseFrame() -> AppFrame {
        let viewLayer = CreateWalletViewController()
        return AppFrame(viewLayer: viewLayer)
    }

    func restoreWalletFrame() -> AppFrame {
        let viewLayer = RestoreWalletViewController()
        return AppFrame(viewLayer: viewLayer)
    }

    func createPasswordFrame() -> AppFrame {
        let presenter = CreatePasswordPresenter()
        let viewLayer = CreatePasswordViewLayer()
        presenter.viewLayer = viewLayer
        presenter.start(with: CreatePasswordParams())
        return AppFrame(viewLayer: viewLayer)
    }

    func transactionInfoFrame<T>(_ transaction: T) -> AppFrame {
        if let theItem = transaction as? CommonTransaction {
            let txType = Transaction.transactionType(theItem)
            let tx = Transaction(theItem.uuid, NSDecimalNumber(string: theItem.amount, locale: NSLocale.current),
                    rawDate: theItem.date, txType)
            tx.destination = (txType == .received) ? theItem.from : theItem.to
            tx.feeString = theItem.fee
            tx.pending = theItem.pending

            let vc = TransactionDetailsViewController(tx)
            return AppFrame(viewLayer: vc)
        }

        let vc = TransactionDetailsViewController()
        return AppFrame(viewLayer: vc)
    }
}
