//
// Created by Igor Efremov on 27/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

enum TransactionBlockchainType: String {
    case create_account_tx, spend_tx, delete_account_tx, new_channel_tx, channel_solo_close, channel_slash_tx, channel_team_close_tx,
         channel_timeout_tx, oracle_new_tx, oracle_bet_tx, oracle_close_tx, oracle_unmatched_tx, oracle_winnings_tx, coinbase_tx, multi_tx

    // TODO: dynamic fee definition (base fee + cost): Light node implementation needed
    var fee: UInt64 {
        let result: UInt64

        switch self {
            case .create_account_tx:
                result = 152168
            case .spend_tx:
                result = 61657
            default:
                result = 61657
        }

        return result
    }
}

enum TranslatedTransactionType: String {
    case create_acc_tx, spend

    var blockChainType: TransactionBlockchainType {
        switch self {
        case .create_acc_tx:
            return .create_account_tx
        case .spend:
            return .spend_tx
        }
    }
}
