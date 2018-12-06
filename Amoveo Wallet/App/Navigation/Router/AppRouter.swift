//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

final class AppRouter {

    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }
}

extension AppRouter: AppRouterProtocol {

    func setRoot(_ controller: UIViewController) {
        window?.rootViewController = controller
    }

    func pushFromTabBar(_ controller: UIViewController, animated: Bool = true) {
        let root = window?.rootViewController as? UITabBarController
        guard let selectedIndex = root?.selectedIndex else { return }
        let navigation = root?.children[selectedIndex] as? UINavigationController
        navigation?.pushViewController(controller, animated: animated)
    }

    func pushFromNavigation(_ controller: UIViewController, animated: Bool = true) {
        let root = window?.rootViewController as? UINavigationController
        root?.pushViewController(controller, animated: animated)
    }

    func present(_ controller: UIViewController, animated: Bool = true) {
        let root = window?.rootViewController as? UITabBarController
        guard let selectedIndex = root?.selectedIndex else { return }
        let navigation = root?.children[selectedIndex] as? UINavigationController
        navigation?.present(controller, animated: animated, completion: nil)
    }

    func successMessage(_ message: String) {
        EXADialogs.showMessage("", title: message, buttonTitle: l10n(.commonContinue))
    }
}
