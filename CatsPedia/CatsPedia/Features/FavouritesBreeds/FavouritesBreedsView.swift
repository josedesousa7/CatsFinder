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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(viewModel.favouritesBreeds, id: \.id) { catBreed in
                            NavigationLink(destination: Text(catBreed.name)) {
                                BreedView(model: catBreed) { }
                                    .padding(.vertical)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Favorites 😺")
        }
    }
}

#Preview {
    //let viewModel = 
    let breeds: [BreedDetail] = [
        BreedDetail(
            id: "Mock-Id-1",
            name: "Mock-name-1",
            imageUrl: nil,
            isFavourite: false
        ),
        BreedDetail(
            id: "Mock-Id-2",
            name: "Mock-name-2",
            imageUrl: nil,
            isFavourite: true
        ),
        BreedDetail(
            id: "Mock-Id-3",
            name: "Mock-name-3",
            imageUrl: nil,
            isFavourite: true
        ),
        BreedDetail(
            id: "Mock-Id-4",
            name: "Mock-name-4",
            imageUrl: nil,
            isFavourite: false
        ),
        BreedDetail(
            id: "Mock-Id-5",
            name: "Mock-name-5",
            imageUrl: nil,
            isFavourite: true
        )
    ]
    FavouritesBreedsView()
}
