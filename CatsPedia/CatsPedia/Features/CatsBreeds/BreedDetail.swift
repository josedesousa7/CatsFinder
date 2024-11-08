//
//  BreedDetail.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation

struct BreedDetail: Identifiable, Hashable {
    let id: String
    let name: String
    let imageUrl: URL?
    var isFavorite: Bool
    var favoriteId: Int?

    mutating func update(with interaction: Bool, id: Int?) {
        isFavorite = interaction
        favoriteId = id
    }
}
