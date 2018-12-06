//
// Created by Igor Efremov on 20/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

class AddressValidator {

    static func isCorrectAddress(_ base64EncodedAddress: String) -> Bool {
        if let decodedData = Data(base64Encoded: base64EncodedAddress) {
            if let sd = SecureData(data: decodedData) {
                if let possibleAddress = sd.hexString() {
                    if possibleAddress.hasPrefix("0x04") && possibleAddress.length == 132 {
                        return true
                    }
                }
            }
        }

        return false
    }
}
