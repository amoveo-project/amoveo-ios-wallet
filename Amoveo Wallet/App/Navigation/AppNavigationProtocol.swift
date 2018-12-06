//
// Created by Igor Efremov on 17/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

typealias DefaultCallback = () -> ()
typealias NavigationData = Data

protocol AppNavigationProtocol {

    var state: NavigationState { get set }

    var onReadyToRoute: DefaultCallback? { get set }
    var onNeedRemoveData: DefaultCallback? { get set }
    var onUpdatedAuthState: AppAuthenticationStateHandler? { get set }

    func defaultUserFlow()
    func regularUserFlow()
    func addressDeepLinkUserFlow(params: AppLinkerAddressWalletParams)

    func presentSingleFrame<T>(for type: AppSingleFrameType, data: T?)
    func presentSingleTab<T>(for frame: AppTabFrameType, with data: T?)
}

protocol EXAAppNavigationDelegate: class {
    func resetWalletAndStartNew()
    func showWalletAfterCreate(_ isRestored: Bool)
}

protocol AppWireframeProtocol {

    var navigation: AppNavigationProtocol? { get set }

    func constructTabFrame(for type: AppTabFrameType) -> AppFrame
    func constructSingleFrame<T>(for type: AppSingleFrameType, data: T?) -> AppFrame
}

