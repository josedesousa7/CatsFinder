//
//  FavoritesReducer.swift
//  CatsPedia
//
//  Created by José Marques on 10/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FavouritesFeature {
    private let apiClient: CatPediaRequestsProtocol = CatPediaApiClient()
    @ObservableState
    struct State: Equatable {
        var favourites: [BreedDetail] = BreedDetail.mock
        var isLoading: Bool = false
    }

    enum Action {
        case fetchFavorites
        case favoritesFetched([BreedDetail])
    }

    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .fetchFavorites:
            state.isLoading = true
            return .run { send in
                let breeds: [Breed] = try await apiClient.fetchBreeds()
                let favorites: [FavoriteBreed] = try await apiClient.fetchFavorites()
                let results = mapToBreedDetail(result: breeds, favorites: favorites)
                await send(.favoritesFetched(results.filter{ $0.isFavourite }))
            }
        case .favoritesFetched(let favourites):
            state.isLoading = false
            state.favourites = favourites
            return .none
        }
      }
    }

}
