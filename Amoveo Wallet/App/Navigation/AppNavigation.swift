//
//  AppNavigation.swift
//
//
//  Created by Igor Efremov on 30/05/2018.
//  Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

enum NavigationState {
    case standard, deepLink
}

// TODO: Refactoring
final class AppNavigation {
    
    var state: NavigationState = .standard

    var onUpdatedAuthState: AppAuthenticationStateHandler?
    var onNeedRemoveData: DefaultCallback?
    var onReadyToRoute: DefaultCallback?
    var isNewWallet = false
    
    private var messageText = ""
    
    private var authentication = AppAuthentication() as AppAuthenticationProtocol
    private var wireframe = AppWireframe() as AppWireframeProtocol
    private var main: (UIViewController & MainTabProtocol)?
    
    // TODO: fix
    private var firstLaunch: Bool = true
    //
    
    private let router: AppRouterProtocol
    private let sequence: AppNavigationPointSequence
    private let hiddingScreen: HidingScreenPresenterProtocol

    init(appRouter: AppRouterProtocol, sequence: AppNavigationPointSequence, hiddingScreen: HidingScreenPresenterProtocol) {
        self.router = appRouter
        self.sequence = sequence
        self.hiddingScreen = hiddingScreen
        
        setupActionDelegate()
        // TODO: fix
        wireframe.navigation = self
        
        onReadyToRoute = { [weak self] in
            self?.presentRoot()
        }
    }
}

extension AppNavigation: AppNavigationProtocol {
    
    func defaultUserFlow() {
        presentOnboarding { [weak self] in
            defer {
                self?.hiddingScreen.dismiss()
            }
            guard self?.state == NavigationState.standard, let point = self?.sequence.point else {
                return
            }
            switch point {
            case .auth:
                self?.presentAuth(with: .validate) {}
            case .wallet:
                self?.presentMain(with: .dashboard)
            case .new, .onboarding:
                self?.presentMainController()
            }
        }
    }
    
    func regularUserFlow() {
        guard state == NavigationState.standard else {
            return
        }
        switch sequence.point {
        case .auth:
            presentAuth(with: .validate, onPresent: { [weak self] in
                self?.hiddingScreen.dismiss()
            })
        case .wallet:
            hiddingScreen.dismiss()
        case .new, .onboarding:
            presentMainController()
            hiddingScreen.dismiss()
        }
    }

    func addressDeepLinkUserFlow(params: AppLinkerAddressWalletParams) {
        guard state == .deepLink else { return }
        switch sequence.point {
        case .auth:
            presentRoot()
            presentPreferredAuth(with: .validate, routeFrame: .send, data: params, onPresent: { [weak self] in
                self?.hiddingScreen.dismiss()
            })
        case .wallet:
            presentSingleTab(for: .send, with: params)
            hiddingScreen.dismiss()
        default:
            //presentMainController()
            //hiddingScreen.dismiss()
            noop()
        }
        state = .standard
    }
    
    func presentSingleFrame<T>(for type: AppSingleFrameType, data: T? = nil) {
        switch type {
        case .main: break
        case .about: presentSingleFrameAbout(data: data)
        case .walletPassphrase: presentSingleFrameWalletPassphrase(data: data)
        case .restoreWallet: presentSingleFrameRestoreWallet(data: data)
        case .createPassword: presentSingleFrameCreatePassword(data: data)
        case .transactionInfo: presentSingleFrameTransactionDetail(data: data)
        }
    }

    func presentSingleTab<T>(for frame: AppTabFrameType, with data: T?) {
        main?.select(frame, with: data)
    }
}

extension AppNavigation: EXAAppNavigationDelegate {
    
    func resetWalletAndStartNew() {
        AppState.sharedInstance.walletInfo = nil
        onNeedRemoveData?()
        presentMainController()
    }
    
    func showWalletAfterCreate(_ isRestored: Bool) {
        AppState.sharedInstance.save()
        isNewWallet = true

        messageText = isRestored ? l10n(.walletRestored) : l10n(.walletCreated)
        presentAuth(with: .create) {}
    }
    
    func setupActionDelegate() {
        EXAAppNavigationDispatcher.sharedInstance.actionDelegate = self
    }
}

private extension AppNavigation {
    
    func presentMain(with frame: AppTabFrameType) {
        let builder = MainTabBuilder(wireframe: wireframe)
        main = MainTab(builder)
        main?.select(frame, with: nil as NavigationData?)
        guard let main = main else { return }
        router.setRoot(main)
    }
    
    func presentAuth(with mode: PinCodeMode, onPresent: @escaping DefaultCallback) {
        authentication.proceed(with: mode)
        authentication.onPresentPin = { onPresent() }
        authentication.onCancelCreate = { [weak self] in
            self?.route()
        }
        authentication.state = { [weak self] state, type in
            self?.onUpdatedAuthState?(state, type)
            switch state {
            case .attempt:
                break
            case .success:
                self?.route(.dashboard)
            case .error:
                break
            }
        }
        authentication.onDismissBiometryScreen = { [weak self] in
            guard let text = self?.messageText else { return }
            self?.router.successMessage(text)
        }
    }
    
    func presentPreferredAuth<T>(with mode: PinCodeMode, routeFrame: AppTabFrameType = .dashboard, data: T?, onPresent: @escaping DefaultCallback) {
        authentication.proceed(with: mode)
        authentication.onPresentPin = { onPresent() }
        authentication.state = { [weak self] state, type in
            self?.onUpdatedAuthState?(state, type)
            switch state {
            case .attempt:
                break
            case .success:
                self?.preferredRoute(routeFrame, data: data)
            case .error:
                break
            }
        }
    }
    
    func presentMainController() {
        let mainController = wireframe.constructSingleFrame(for: .main, data: nil as Bool?).viewLayer
        let vc = mainController.children[0] as? MainViewController
        vc?.navigation = self
        router.setRoot(mainController)
    }
    
    func presentRoot() {
        let defaultVC = RootViewController()
        router.setRoot(defaultVC)
    }
    
    func presentOnboarding(handler: @escaping DefaultCallback) {
        if sequence.point == .onboarding {
            onboarding { handler() }
        } else {
            let settings = AppSettingsModel()
            if !settings.showOnboarding {
                onboarding { handler() }
            } else {
                handler()
            }
        }
    }
    
    func onboarding(handler: @escaping DefaultCallback) {
        let onboarding = OnboardingAWPresenter()
        router.setRoot(onboarding)
        onboarding.onHide = handler
    }
}

private extension AppNavigation {
    
    func route(_ routeFrame: AppTabFrameType = .dashboard) {
        switch sequence.point {
        case .auth:
            if firstLaunch {
                presentMain(with: routeFrame)
                presentSingleTab(for: routeFrame, with: nil as NavigationData?)
                firstLaunch = false
            } else if isNewWallet {
                presentMain(with: routeFrame)
                presentSingleTab(for: routeFrame, with: nil as NavigationData?)
                isNewWallet = false
            }
        case .new, .onboarding:
            break
        case .wallet:
            presentMain(with: routeFrame)
        }
    }
    
    func preferredRoute<T>(_ routeFrame: AppTabFrameType = .dashboard, data: T?) {
        switch sequence.point {
        case .auth:
            presentMain(with: routeFrame)
            presentSingleTab(for: routeFrame, with: data)
        case .new,. onboarding:
            break
        case .wallet:
            break
        }
    }
}

private extension AppNavigation {
    
    func presentSingleFrameAbout<T>(data: T?) {
        let frame = wireframe.constructSingleFrame(for: .about, data: data)
        let viewLayer = frame.viewLayer.children[0]
        router.pushFromNavigation(viewLayer, animated: true)
    }
    
    func presentSingleFrameWalletPassphrase<T>(data: T?) {
        let frame = wireframe.constructSingleFrame(for: .walletPassphrase, data: data)
        guard let viewLayer = frame.viewLayer as? CreateWalletViewController else { return }
        viewLayer.navigation = self
        router.pushFromNavigation(viewLayer, animated: true)
    }
    
    func presentSingleFrameCreatePassword<T>(data: T?) {
        let frame = wireframe.constructSingleFrame(for: .createPassword, data: data)
        router.pushFromNavigation(frame.viewLayer, animated: true)
    }
    
    func presentSingleFrameRestoreWallet<T>(data: T?) {
        let frame = wireframe.constructSingleFrame(for: .restoreWallet, data: data)
        router.pushFromNavigation(frame.viewLayer, animated: true)
    }

    func presentSingleFrameTransactionDetail<T>(data: T?) {
        let frame = wireframe.constructSingleFrame(for: .transactionInfo, data: data)
        router.pushFromTabBar(frame.viewLayer, animated: true)
    }
}
