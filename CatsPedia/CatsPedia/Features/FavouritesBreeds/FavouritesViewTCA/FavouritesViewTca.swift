//
//  FavouritesViewTca.swift
//  CatsPedia
//
//  Created by José Marques on 10/11/2024.
//

import ComposableArchitecture
import SwiftUI

struct FavouritesViewTca: View {
    
    var gridItems: [GridItem] = (1...3).map { _ in
        GridItem(.flexible())
    }
    
    var store: StoreOf<FavouritesFeature>
    @EnvironmentObject var viewModel: BreedsListViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(store.favourites, id: \.id) { catBreed in
                            NavigationLink(destination: BreedDetailView(breed: catBreed)
                                .environmentObject(viewModel)) {
                                BreedView(
                                    name: catBreed.name,
                                    caption: catBreed.lifeSpan,
                                    isFavourite: catBreed.isFavourite,
                                    imageUrl: catBreed.imageUrl
                                ) { }
                                    .padding(.vertical)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .redacted(reason: store.isLoading ? .placeholder: [])
            .onAppear {
                store.send(.fetchFavorites)
            }
            .navigationTitle("Favorites 😺")
        }
    }
}

#Preview {
    let mockViewModel: BreedsListViewModel = BreedsListViewModelMock(
        state: .loaded(result: BreedDetail.mock)
    )
    FavouritesViewTca(store: Store(initialState: FavouritesFeature.State(), reducer: {
        FavouritesFeature()
    }))
    .environmentObject(mockViewModel)
}

