//
//  FavoritesBreeds.swift
//  CatsPedia
//
//  Created by José Marques on 09/11/2024.
//

import SwiftUI

struct FavouritesBreedsView: View {

    var gridItems: [GridItem] = (1...3).map { _ in
        GridItem(.flexible())
    }

    @EnvironmentObject var viewModel: BreedsListViewModel
    @State var favorites: [BreedDetail]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(favorites, id: \.id) { catBreed in
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
                .onAppear {
                    favorites = viewModel.favouritesBreeds
                }
                .onDisappear {
                    favorites = []
                }
            }
            .navigationTitle("Favorites 😺")
        }
    }
}

#Preview {
    let breeds: [BreedDetail] = [
        BreedDetail(
            id: "Mock-Id-1",
            name: "Mock-name-1",
            lifeSpan: nil,
            origin: nil,
            temperament: nil,
            description: nil,
            imageUrl: nil,
            isFavourite: false
        ),
        BreedDetail(
            id: "Mock-Id-2",
            name: "Mock-name-2",
            lifeSpan: nil,
            origin: nil,
            temperament: nil,
            description: nil,
            imageUrl: nil,
            isFavourite: true
        ),
        BreedDetail(
            id: "Mock-Id-3",
            name: "Mock-name-3",
            lifeSpan: nil,
            origin: nil,
            temperament: nil,
            description: nil,
            imageUrl: nil,
            isFavourite: true
        ),
        BreedDetail(
            id: "Mock-Id-4",
            name: "Mock-name-4",
            lifeSpan: nil,
            origin: nil,
            temperament: nil,
            description: nil,
            imageUrl: nil,
            isFavourite: false
        ),
        BreedDetail(
            id: "Mock-Id-5",
            name: "Mock-name-5",
            lifeSpan: nil,
            origin: nil,
            temperament: nil,
            description: nil,
            imageUrl: nil,
            isFavourite: true
        )
    ]

    let mockViewModel: BreedsListViewModel = BreedsListViewModelMock(
        state: .loaded(result: breeds)
    )
    
    FavouritesBreedsView(favorites: breeds)
        .environmentObject(mockViewModel)
}
