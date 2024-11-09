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
        let favoriteIdIndex = favoritesId.firstIndex(where: { id == $0 })
        let isFavorite = favoritesId.contains { $0 == id }
        let lifeSpan = breed.lifeSpan?.components(separatedBy: " - ").first.map {
            return  "life expectancy: \($0)"
        }

        return BreedDetail(
            id: id,
            name: name,
            lifeSpan: lifeSpan,
            origin: breed.origin,
            temperament: breed.temperament,
            description: breed.description,
            imageUrl: breed.image?.url.flatMap(URL.init),
            isFavourite: isFavorite,
            favouriteId: favorites[safe: favoriteIdIndex]?.id
        )
    }
}

func mapToBreedDetailPersistance(breeds: [BreedDetail]) throws -> [BreedDetailPersistance] {
    return breeds.map { breed -> BreedDetailPersistance in
        return BreedDetailPersistance(
            id: breed.id,
            name: breed.name,
            lifeSpan: breed.lifeSpan,
            origin: breed.origin,
            temperament: breed.temperament,
            breedDescription: breed.description,
            imageUrl: breed.imageUrl,
            isFavourite: breed.isFavourite,
            favouriteId: breed.favouriteId
        )
    }
}
