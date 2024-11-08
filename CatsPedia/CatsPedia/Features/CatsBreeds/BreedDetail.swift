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

    mutating func update(with breed: BreedDetail) {
        isFavorite = breed.isFavorite
    }
}
