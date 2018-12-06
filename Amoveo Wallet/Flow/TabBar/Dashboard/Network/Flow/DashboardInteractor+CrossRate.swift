//
// Created by Igor Efremov on 26/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

extension DashboardInteractor {

    func updateCrossRate() {
        var service = AWCrossRateService() as CrossRateServiceProtocol
        let rateTicker = AppState.sharedInstance.settings.selectedCurrency.rawValue

        service.onUpdateValue = { [weak self] rate in
            DispatchQueue.main.async {
                AppState.sharedInstance.currentRate = rate
                self?.onCrossRateUpdated?(rate, rateTicker)
            }
        }

        service.update()
    }
}
