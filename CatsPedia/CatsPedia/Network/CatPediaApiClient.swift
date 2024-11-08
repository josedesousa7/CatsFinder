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
}
