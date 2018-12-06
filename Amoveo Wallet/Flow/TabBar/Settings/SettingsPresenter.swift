//
// Created by Igor Efremov on 30/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class SettingsPresenter {
    var viewLayer: SettingsViewProtocol?
    var navigation: AppNavigationProtocol?

    func start() {
        subscriptForViewEvents()
    }

    func subscriptForViewEvents() {
        viewLayer?.onAboutSelected = showAbout
    }

    func showAbout() {
        navigation?.presentSingleFrame(for: .about, data: nil as Bool?)
    }
}
