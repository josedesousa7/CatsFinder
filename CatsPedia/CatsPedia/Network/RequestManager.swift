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
    func post<T: Codable>(_ request: URLRequest) async throws -> T
    func delete<T: Codable>(_ request: URLRequest) async throws -> T
}

struct RequestManager: HttpProtocol {

    private let session = URLSession.shared

    func fetch<T: Codable>(_ request: URLRequest) async throws -> T {

        return try await performRequest(request)
    }

    func post<T: Codable>(_ request: URLRequest) async throws -> T {
        guard request.httpMethod == "POST" else {
            throw URLError(.badURL)
        }

        return try await performRequest(request)
    }

    func delete<T: Codable>(_ request: URLRequest) async throws -> T {
        guard request.httpMethod == "DELETE" else {
            throw URLError(.badURL)
        }
        return try await performRequest(request)
    }

    private func performRequest<T>(_ request: URLRequest) async throws -> T where T : Codable {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
