//
//  Mapper.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//
import Foundation

func mapToBreedDetail(result: [Breed], favorites: [FavoriteBreed]) throws -> [BreedDetail] {
    return result.compactMap { breed -> BreedDetail? in
        guard let name = breed.name, let id = breed.id else { return nil }
        let favoritesId = favorites.map { $0.imageId }
        let isFavorite = favoritesId.contains { $0 == id }
        return BreedDetail(
            id: id,
            name: name,
            imageUrl: breed.image?.url.flatMap(URL.init),
            isFavorite: isFavorite
        )
    }
}
