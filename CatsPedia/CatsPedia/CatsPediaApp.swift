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
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BreedDetailPersistance.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

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
        .modelContainer(sharedModelContainer)
    }
}
