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
    @ObservableState
    struct State: Equatable {
        var favourites: [BreedDetail] = []
        var isLoading: Bool = true
    }

    enum Action {
        case fetchFavorites
        //case favoritesFetched([BreedDetail])
    }

    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .fetchFavorites:
            let favourites = (1...5).map {
                BreedDetail(
                    id: "mock - id\($0)",
                    name: "mock - id\($0)",
                    lifeSpan: "mock - id\($0)",
                    origin: "mock - id\($0)",
                    temperament: "mock - id\($0)",
                    description: "mock - id\($0)",
                    imageUrl: nil,
                    isFavourite: true
                )
            }
            state.favourites = favourites
            return .none
//        case .favoritesFetched:
//            state.favourites = favourites

        }
      }
    }

}
