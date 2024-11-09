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

@MainActor
class BreedsRepository: BreedsRepositoryProtocol {

    private let apiClient: CatPediaRequestsProtocol
    private let dataPersistance: SwiftDataService

    init(apiClient: CatPediaRequestsProtocol = CatPediaApiClient()) {
        self.apiClient = apiClient
        self.dataPersistance = SwiftDataService()
    }

    func fetchBreedList() async throws -> [BreedDetail] {
        var breeds: [BreedDetail] = []
        do {
            let breedList: [Breed] = try await apiClient.fetchBreeds()
            let favorites = try await fecthFavorites()
            let breedDetail = mapToBreedDetail(result: breedList, favorites: favorites)
            try updateDatase(with: breedDetail)
            breeds = mapToBreedDetail(result: breedList, favorites: favorites)
            return breeds
        } catch (let error) {
            if error.localizedDescription == "The Internet connection appears to be offline." {
                let persistedResults = dataPersistance.fetch()
                return mapToBreedDetail(breeds: persistedResults)
            }

        }
        return breeds
    }

    private func updateDatase(with breeds: [BreedDetail]) throws {
        let dataPersistanceObjects = mapToBreedDetailPersistance(breeds: breeds)
        dataPersistanceObjects.forEach { item in
            dataPersistance.addBreed(item)
        }
    }

    func fetchMoreBreeds(page: Int) async throws -> [BreedDetail] {
        let favorites = try await fecthFavorites()
        let breedList: [Breed] = try await apiClient.fetchMoreBreeds(page: page)
        let breedDetail = mapToBreedDetail(result: breedList, favorites: favorites)
        try updateDatase(with: breedDetail)
        return mapToBreedDetail(result: breedList, favorites: favorites)
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
        guard let id = breed.favouriteId else { return false }
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
        return []
    }
    
    func fetchBreedList() async throws -> [BreedDetail] {
        return BreedDetail.mock
    }

    func fecthFavorites() async throws -> [FavoriteBreed] {
        return []
    }
}
#endif
