//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit

protocol AppRouterProtocol {
    func setRoot(_ controller: UIViewController)
    func pushFromTabBar(_ controller: UIViewController, animated: Bool)
    func pushFromNavigation(_ controller: UIViewController, animated: Bool)
    func present(_ controller: UIViewController, animated: Bool)
    func successMessage(_ message: String)
}
