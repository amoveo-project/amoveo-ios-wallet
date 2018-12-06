//
//  AppCoordinator.swift
//
//
//  Created by Vladimir Malakhov on 30/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

final class AppCoordinator {
    
    var onReadyToRoute: DefaultCallback?
    
    private let container : AppContainerProtocol
    private var navigation: AppNavigationProtocol
    
    init(appContainer: AppContainerProtocol, appNavigation: AppNavigationProtocol) {
        self.container  = appContainer
        self.navigation = appNavigation
        
        subscriptForEvents()
    }
}

extension AppCoordinator: AppCoordinatorProtocol {
    
    func updateUserFlow(with type: AppCoordinatorState) {
        switch type {
        case .default:
            DispatchQueue.main.async {
                self.navigation.defaultUserFlow()
            }
        case .regular:
            DispatchQueue.main.async {
                self.navigation.regularUserFlow()
            }
        }
    }
    
    func setupApp(with type: AppCoordinatorState) {
        switch type {
        case .default:
            defaultAppSetup()
        case .regular:
            regularAppSetup()
        }
    }
    
    func saveAppData() {
        AppState.sharedInstance.save()
    }
}

private extension AppCoordinator {
    
    func defaultAppSetup() {
        loadWallet(for: .default)
        container.appearance.setupUI()
        container.interactor.updateSettingData()
    }
    
    func regularAppSetup() {
        container.interactor.updateSettingData()
        guard AppState.sharedInstance.walletInfo == nil else { return }
        container.interactor.updateData()
        loadWallet(for: .regular)
    }
    
    func loadWallet(for state: AppCoordinatorState) {
        if state == .default {
            navigation.onReadyToRoute?()
        }
        let loader = WalletsLoader()
        loader.load { (walletInfo) in
            AppState.sharedInstance.walletInfo = walletInfo
            if state == .default {
                self.updateUserFlow(with: .default)
            }
        }
    }
}

private extension AppCoordinator {
    
    func subscriptForEvents() {
        var copyObjectNavigation = navigation
        copyObjectNavigation.onNeedRemoveData = {
            AppState.sharedInstance.settings.reset()
        }
    }
}
