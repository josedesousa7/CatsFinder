//
//  BreedDetail.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation
import SwiftData

struct BreedDetail: Identifiable, Hashable {
    let id: String
    let name: String
    let lifeSpan: String?
    let origin: String?
    let temperament: String?
    let description: String?
    let imageUrl: URL?
    var isFavourite: Bool
    var favouriteId: Int?

    mutating func update(with interaction: Bool, id: Int?) {
        isFavourite = interaction
        favouriteId = id
    }
}
