//
//  CatsPediaApp.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

import SwiftUI
import SwiftData

@main
struct CatsPediaApp: App {
    let viewModel = BreedsListViewModel(
        repository: BreedsRepository()
    )

    var body: some Scene {
        WindowGroup {
            TabView {
                BreedsView(viewModel: viewModel)
                .tabItem {
                    Label("Cats 😺", systemImage: "list.dash")
                }
                FavouritesBreedsView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
        }
    }
}
