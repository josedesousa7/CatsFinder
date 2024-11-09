//
//  CatPediaApiClient.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

import Foundation
import Combine

protocol CatPediaRequestsProtocol {
    func fetchBreeds<T: Codable>() async throws -> T
    func fetchMoreBreeds<T: Codable>(page: Int) async throws -> T
    func fetchFavorites<T: Codable>() async throws -> T
    func createFavorite<T: Codable>(id: String) async throws -> T
    func removeFavorite<T: Codable>(id: Int) async throws -> T
}

struct CatPediaApiClient: CatPediaRequestsProtocol {

    private let requestManager: HttpProtocol
    private let requestBuilder: RequestBuilder

    init(builder: RequestBuilder = RequestBuilder(), requestManager: HttpProtocol = RequestManager()) {
        self.requestBuilder = builder
        self.requestManager = requestManager

    }

    func fetchBreeds<T: Codable>() async throws -> T {
        do {
            return try await requestManager.fetch(requestBuilder.buildGetUrlRequest())
        }
    }

    func fetchMoreBreeds<T: Codable>(page: Int) async throws -> T {
        do {
            return try await requestManager.fetch(requestBuilder.buildGetUrlRequest(page: page))
        }
    }

    func fetchFavorites<T: Codable>() async throws -> T {
        do {
            return try await requestManager.fetch(requestBuilder.buildFavoritesUrlRequest())
        }
    }

    func createFavorite<T: Codable>(id: String) async throws -> T {
        do {
            return try await requestManager.post(requestBuilder.buildCreateFavoritesUrlRequest(id: id))
        }
    }

    func removeFavorite<T: Codable>(id: Int) async throws -> T {
        do {
            return try await requestManager.delete(requestBuilder.buildDeleteFavoritesUrlRequest(id: id))
        }
    }

}

