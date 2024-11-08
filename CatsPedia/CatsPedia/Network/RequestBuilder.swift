//
//  RequestBuilder.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

import Foundation

enum NetworkError: Error {
    case noApiKeyAvailable
}

struct RequestBuilder {

    private var baseUrlComponentes: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.thecatapi.com"
        return components
    }

    private func buildURL(page: Int = 0) throws -> URL {
        var baseUrlComponents = baseUrlComponentes
        baseUrlComponents.path = "/v1/breeds"
        baseUrlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "page", value: String(page))
        ]

        guard let url = baseUrlComponents.url else { throw URLError(.badURL)}
        return url
    }

    private func fetchApiKey() throws -> String? {
        if let path = Bundle.main.path(forResource: "AppSecrets", ofType: "plist") {
            if let plistDict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return plistDict["APIKey"] as? String
            }
        }
        throw NetworkError.noApiKeyAvailable
    }

    func buildGetUrlRequest(page: Int = 0) throws -> URLRequest {
        var urlRequest = try URLRequest(url: buildURL(page: page))
        urlRequest.setValue(try fetchApiKey(), forHTTPHeaderField: "x-api-key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
