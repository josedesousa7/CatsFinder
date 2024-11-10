//
//  SwiftDataManager.swift
//  CatsPedia
//
//  Created by José Marques on 09/11/2024.
//

import Foundation
import SwiftData

class SwiftDataService {
    var modelContainer: ModelContainer = {
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

    private let modelContext: ModelContext

    @MainActor
    init() {
        self.modelContext = modelContainer.mainContext
    }

    func fetch() -> [BreedDetailPersistance] {
        do {
            return try modelContext.fetch(FetchDescriptor<BreedDetailPersistance>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func addBreed(_ breed: BreedDetailPersistance) {
        modelContext.insert(breed)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
