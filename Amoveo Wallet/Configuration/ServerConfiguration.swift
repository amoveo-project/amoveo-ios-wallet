//
// Created by Igor Efremov on 30/05/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation

protocol ServerConfiguration {
    var host: String { get }
    var httpSecure: Bool { get}
    var port: Int { get }
    var url: URL? { get }
    var stage: Bool { get }
}

class BaseServerConfiguration: ServerConfiguration {
    private let httpsPrefix = "https"
    private let httpPrefix = "http"

    private var _host: String
    private var _httpSecure: Bool
    private var _port: Int
    private var _stage: Bool

    var host: String {
        return _host
    }

    var httpSecure: Bool {
        return _httpSecure
    }

    var port: Int {
        return _port
    }

    var stage: Bool {
        return _stage
    }

    var url: URL? {
        var uc = URLComponents()
        uc.scheme = _httpSecure ? httpsPrefix : httpPrefix
        uc.host = host
        uc.port = port

        return uc.url
    }

    init(_ host: String, httpSecure: Bool, stage: Bool = true, port: Int = 80) {
        _host = host
        _httpSecure = httpSecure
        _port = port
        _stage = stage

        let serverType = stage ? "Stage" : "Live"

        print("== Init \(serverType) Server Configuration ==")
        print("\t Host: \(_host), Secure: \(_httpSecure)")
    }
}
