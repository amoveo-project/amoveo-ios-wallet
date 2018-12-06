//
//  MainTab.swift
//
//
//  Created by Igor Efremov on 02/07/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

protocol MainTabProtocol {
    func select<T>(_ typeFrame: AppTabFrameType, with data: T?)
}

final class MainTab: EXATabViewController {
    
    private var builder: MainTabBuilderProtocol
    
    init(_ builder: MainTabBuilderProtocol) {
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
        
        let receive = builder.assembly(.receive)
        let send = builder.assembly(.send)
        let dashboard = builder.assembly(.dashboard)
        let setting = builder.assembly(.settings)

        add([receive, send, dashboard, setting])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainTab: MainTabProtocol {

    func select<T>(_ typeFrame: AppTabFrameType, with data: T?) {
        let tab = selectTab(for: typeFrame)
        appendData(tab, data)
    }
}

private extension MainTab {
    
    func selectTab(for typeFrame: AppTabFrameType) -> ViewLayer? {
        let navigationController = children[typeFrame.position] as? UINavigationController
        selectedViewController = navigationController
        return navigationController?.children[0]
    }
}

private extension MainTab {

    func appendData<T>(_ viewLayer: ViewLayer?, _ data: T?) {
        guard let data = data else { return }
        switch viewLayer {
        case let viewLayer as SendViewController:
            appendAddressForSend(viewLayer, data: data)
        default:
            break
        }
    }

    func appendAddressForSend<T>(_ viewLayer: SendViewController, data: T?) {
        guard let params = data as? AppLinkerAddressWalletParams else { return }
        viewLayer.setupSendParams(params)
    }
}
