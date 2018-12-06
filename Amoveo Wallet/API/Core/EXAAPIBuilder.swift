//
// Created by Igor Efremov on 14/08/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import Foundation
import SwiftyJSON

enum HTTPMethod: String {
    case post, get, put, head
}

enum HTTPHeaderName: String {
    case contentType

    var name: String {
        switch self {
        case .contentType:
            return "Content-Type"
        }
    }
}

class EXAAPIBuilder {
    private var environment: AmoveoEnvironment
    private let apiContentType = "text/plain"

    init(environment: AmoveoEnvironment = .production) {
        self.environment = environment
    }

    func buildExplorerRequest(_ base64Address: String, timeInterval: TimeInterval = 0) -> URLRequest? {
        guard let url = urlToExplorerEndPoint(base64Address) else { return nil }
        print("\tPrepare explorer request url: \(url.absoluteString)")
        let req = buildRequest(url, method: .get)
        print("\tRequest: \(req), method: \(req.httpMethod ?? "")")

        return req
    }

    func buildApiRequest(_ endPoint: String, method: HTTPMethod = .post, headers: [String: String]? = nil,
                         payload: Jsonable? = nil, textPayload: String? = nil, timeInterval: TimeInterval = 0) -> URLRequest? {
        guard let url = urlToApiEndPoint(endPoint) else { return nil }
        print("\tPrepare request url: \(url.absoluteString)")
        let req = buildRequest(url, method: method, headers: headers, params: payload, textParams: textPayload)

        print("\tRequest: \(req), method: \(req.httpMethod ?? "")")
        if let theHeader = (headers?.values.compactMap{$0}) {
            print("\t\tHeader: \(theHeader)")
        }

        if let thePayload = payload?.json()?.description {
            print("\t\tPayload: \(thePayload)")
        }

        return req
    }

    func urlToApiEndPoint(_ endPoint: String) -> URL? {
        return environment.url
    }

    func urlToExplorerEndPoint(_ endPoint: String) -> URL? {
        return URL(string: environment.explorer + endPoint)
    }

    func buildRequest(_ url: URL, method: HTTPMethod, headers: [String: String]? = nil,
                      params: Jsonable? = nil, textParams: String? = nil, timeInterval: TimeInterval = 0) -> URLRequest {
        var request = URLRequest(url: url)
        if timeInterval > 0 {
            request.timeoutInterval = timeInterval
        }

        addHeaders(&request, headers: headers)
        addMethod(&request, method)
        addParams(&request, params)
        addTextParams(&request, textParams)

        return request
    }

    func buildSessionRequestHeaders(nonce: UInt64, signature: String) -> [String: String]? {
        /*guard let meta = AppState.sharedInstance.currentWalletInfo else { return nil }
        guard let sessionId = AppState.sharedInstance.sessionId(for: meta.metaInfo.uuid) else {
            print("Session Id not defined")
            return nil
        }

        return ["X-Session-Id": sessionId,
                   "X-Nonce": String(nonce),
                   "X-Signature": signature]*/
        return nil
    }

    private func addHeaders(_ request: inout URLRequest, headers: [String: String]?) {
        //request.addValue(apiContentType, forHTTPHeaderField: HTTPHeaderName.contentType.name)
        if let theHeaders = headers {
            for field in theHeaders {
                request.addValue(field.value, forHTTPHeaderField: field.key)
            }
        }
    }

    private func addMethod(_ request: inout URLRequest, _ method: HTTPMethod) {
        request.httpMethod = method.rawValue
    }

    private func addParams(_ request: inout URLRequest, _ params: Jsonable?) {
        guard let json = params?.json() else {
            return
        }

        request.httpBody = try? json.rawData()
    }

    private func addTextParams(_ request: inout URLRequest, _ params: String?) {
        guard let params = params else {
            return
        }

        request.httpBody = params.data(using: .utf8)
    }
}
