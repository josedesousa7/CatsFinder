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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            BreedsView(viewModel: BreedsListViewModel(repository: .init()))
        }
        .modelContainer(sharedModelContainer)
    }
}
