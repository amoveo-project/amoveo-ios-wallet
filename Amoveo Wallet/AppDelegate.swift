//
//  AppDelegate.swift
//  Amoveo Wallet
//
//  Created by Igor Efremov on 17/10/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinatorProtocol?

    private var appLinker = AppLinker()
    private var sequence = AppNavigationPointSequence(PincodeTimer())
    private var appInstruction  = AppInstructionLaunch() as AppInstructionLaunchProtocol
    private var appHidingScreen = HidingScreenPresenter() as HidingScreenPresenterProtocol


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !setupFabric() {
            NSLog("Unable to setup Fabric")
        }
        
        createWindow()

        let appContainer  = createAppContainer()
        let appNavigation = createAppNavigation()
        appCoordinator = AppCoordinator(appContainer: appContainer, appNavigation: appNavigation)
        appCoordinator?.setupApp(with: .default)
        setupLinker(with: appNavigation)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appInstruction.instruction(required: { [weak self] in
            self?.appCoordinator?.setupApp(with: .regular)
        }, optional: { [weak self] in
            self?.appCoordinator?.updateUserFlow(with: .regular)
        })
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        appLinker.handle(with: url)
        return true
    }
}

private extension AppDelegate {

    func createWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    func createAppContainer() -> AppContainer {
        return AppContainer()
    }

    func createAppNavigation() -> AppNavigation {
        let appRouter = AppRouter(window: window)
        let appNavigation = AppNavigation(appRouter: appRouter,
                sequence: sequence,
                hiddingScreen: appHidingScreen)
        appNavigation.onUpdatedAuthState = { state, type in
            switch type {
            case .bio:
                self.appInstruction.authBioState = state
            case .pin:
                self.appInstruction.authPinState = state
            }
        }
        return appNavigation
    }
    
    func setupFabric() -> Bool {
        guard let fabricApiKey = EXACommon.loadApiKey(AmoveoConstants.fabricApiKeyPath) else {
            NSLog("Unable to get Fabric api key")
            return false
        }

        Crashlytics.start(withAPIKey: fabricApiKey.trim())

        return true
    }

    func setupLinker(with appNavigation: AppNavigationProtocol) {
        appLinker.navigation = appNavigation
    }
}

