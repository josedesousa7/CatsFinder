//
//  HttpClient.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

import Foundation
import Combine

protocol HttpProtocol {
    func fetch<T: Codable>(_ request: URLRequest) async throws -> T
    func post<S: Codable>(_ request: URLRequest) async throws -> S
}

struct RequestManager: HttpProtocol {
    
   private let session = URLSession.shared

    func fetch<T: Codable>(_ request: URLRequest) async throws -> T {

        let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        }

    func post<S: Codable>(_ request: URLRequest) async throws -> S {
        guard request.httpMethod == "POST" else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(S.self, from: data)
        return result
    }
}
