//
// Created by Igor Efremov on 19/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol BalanceStorageProtocol {
    func setBalance(amount: AmountValue?, for ticker: CryptoTicker)
    func setBalance(amount: String?, for ticker: CryptoTicker)
    func getBalance(ticker: CryptoTicker) -> AmountValue?
}
