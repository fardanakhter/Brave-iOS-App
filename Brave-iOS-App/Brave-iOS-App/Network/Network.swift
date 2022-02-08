//
//  Network.swift
//  Brave-iOS-App
//
//  Copyright © 2022 Onseen. All rights reserved.
//

import Foundation

struct Network {
    private var baseURL: String { "api.coingecko.com" }

    enum NetworkError: Error {
        case invalidURL
        case network
        case dataNotFound
        case decoding
    }

    enum NetworkMethod: String {
        case get = "GET"
    }

    private func endpointURL(withPath path: String) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = "/api/v3" + path

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    func urlRequest(withMethod method: NetworkMethod, path: String, timeout: TimeInterval? = nil) throws -> URLRequest {
        let endpoint = try endpointURL(withPath: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = method.rawValue
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        return request
    }
}
