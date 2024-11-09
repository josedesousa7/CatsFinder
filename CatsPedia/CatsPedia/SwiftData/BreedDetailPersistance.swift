//
//  BreedDetailPersistance.swift
//  CatsPedia
//
//  Created by José Marques on 09/11/2024.
//

import Foundation
import SwiftData

@Model
class BreedDetailPersistance {

    @Attribute(.unique) var id: String
    var name: String
    var lifeSpan: String?
    var origin: String?
    var temperament: String?
    var breedDescription: String?
    var imageUrl: URL?
    var isFavourite: Bool
    var favouriteId: Int?

    init(
        id: String,
        name: String,
        lifeSpan: String?,
        origin: String?,
        temperament: String?,
        breedDescription: String?,
        imageUrl: URL?,
        isFavourite: Bool,
        favouriteId: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.lifeSpan = lifeSpan
        self.origin = origin
        self.temperament = temperament
        self.breedDescription = breedDescription
        self.imageUrl = imageUrl
        self.isFavourite = isFavourite
        self.favouriteId = favouriteId
    }
}
