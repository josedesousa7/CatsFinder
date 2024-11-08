//
//  BreedsRepository.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation

protocol BreedsRepositoryProtocol {
    func fetchBreedList() async throws -> [BreedDetail]
    func fetchMoreBreeds(page: Int) async throws -> [BreedDetail]
    func fecthFavorites() async throws -> [FavoriteBreed]
    func createFavorite(for breed: BreedDetail) async throws -> FavoriteCreationResponse
    func removeFavorite(for breed: BreedDetail) async throws -> Bool
}

struct BreedsRepository: BreedsRepositoryProtocol {

    private let apiClient: CatPediaRequestsProtocol

    init(apiClient: CatPediaRequestsProtocol = CatPediaApiClient()) {
        self.apiClient = apiClient
    }

    func fetchBreedList() async throws -> [BreedDetail] {
        let breedList: [Breed] = try await apiClient.fetchBreeds()
        let favorites = try await fecthFavorites()
        return try mapToBreedDetail(result: breedList, favorites: favorites)
    }

    func fetchMoreBreeds(page: Int) async throws -> [BreedDetail] {
        let favorites = try await fecthFavorites()
        let breedList: [Breed] = try await apiClient.fetchMoreBreeds(page: page)
        return try mapToBreedDetail(result: breedList, favorites: favorites)
    }

    func fecthFavorites() async throws -> [FavoriteBreed] {
        let favorites: [FavoriteBreed] = try await apiClient.fetchFavorites()
        return favorites
    }

    func createFavorite(for breed: BreedDetail) async throws -> FavoriteCreationResponse {
        let response: FavoriteCreationResponse = try await apiClient.createFavorite(id: breed.id)
        return response
    }

    func removeFavorite(for breed: BreedDetail) async throws -> Bool {
        guard let id = breed.favoriteId else { return false }
        let response: FavoriteCreationResponse = try await apiClient.removeFavorite(id: id)
        return response.message == "SUCCESS"
    }
}

#if targetEnvironment(simulator)
struct BreedsRepositoryMock: BreedsRepositoryProtocol {
    func createFavorite(for breed: BreedDetail) async throws -> FavoriteCreationResponse {
        return FavoriteCreationResponse(message: "", id: 3)
    }
    
    func removeFavorite(for breed: BreedDetail) async throws -> Bool {
        false
    }
    

    func fetchMoreBreeds(page: Int) async throws -> [BreedDetail] {
        return BreedDetail.mock
    }
    
    func fetchBreedList() async throws -> [BreedDetail] {
        return BreedDetail.mock
    }

    func fecthFavorites() async throws -> [FavoriteBreed] {
        return []
    }
}
#endif
