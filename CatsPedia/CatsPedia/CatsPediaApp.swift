//
//  CatsPediaApp.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct CatsPediaApp: App {
    let viewModel = BreedsListViewModel(
        repository: BreedsRepository()
    )
    
    static let store = Store(initialState: FavouritesFeature.State(), reducer: {
        FavouritesFeature()
    })
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BreedsView(viewModel: viewModel)
                    .tabItem {
                        Label("Cats 😺", systemImage: "list.dash")
                    }
                FavouritesViewTca(store: CatsPediaApp.store)
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
        }
    }
}
