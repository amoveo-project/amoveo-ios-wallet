//
// Created by Igor Efremov on 23/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

extension URL {

    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        if let parameters = url.queryItems {
            return parameters.first(where: { $0.name == queryParam })?.value
        } else if let paramPairs = url.fragment?.components(separatedBy: "?").last?.components(separatedBy: "&") {
            for pair in paramPairs where pair.contains(queryParam) {
                return pair.components(separatedBy: "=").last
            }
        }

        return nil
    }
}
