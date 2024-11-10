//
//  MapperTests.swift
//  CatsPediaTests
//
//  Created by José Marques on 10/11/2024.
//

import Testing
import Foundation
@testable import CatsPedia

struct MapperTests {

    @Test func mapBreedToBreedDetail() {
        let breeds: [Breed] = (1...10).map {
            Breed(
                id: UUID().uuidString,
                name: "name - \($0)",
                origin: "origin - \($0)",
                lifeSpan: "lifespan - \($0)",
                temperament: "temperament - \($0)",
                description: "description - \($0)",
                image: nil
            )
        }
        let breedDetail = mapToBreedDetail(result: breeds, favorites: [])
        #expect(breedDetail.count == 10)
    }

    @Test func mapBreedToBreedDetailWithFavorite() throws {
        let breeds: [Breed] = (1...5).map {
            Breed(
                id: "id - \($0)",
                name: "name - \($0)",
                origin: "origin - \($0)",
                lifeSpan: "lifespan - \($0)",
                temperament: "temperament - \($0)",
                description: "description - \($0)",
                image: nil
            )
        }

        let favourite1 = FavoriteBreed(id: nil, userId: nil, imageId: "id - 1")
        let favourite2 = FavoriteBreed(id: nil, userId: nil, imageId: "id - 2")
        let breedDetail = mapToBreedDetail(result: breeds, favorites: [favourite1, favourite2])
        let expectedResult1 = try #require(breedDetail.first)
        let expectedResult2 = breedDetail[1]
        let expectedResult3 = breedDetail[3]
        #expect(expectedResult1.isFavourite == true)
        #expect(expectedResult2.isFavourite == true)
        #expect(expectedResult3.isFavourite == false)
    }

    @Test func mapBreedToBreedDetailNotIncludeNilNamesOrId() {
        let breeds: [Breed] = [
            Breed(
                id: nil,
                name: "name",
                origin: nil,
                lifeSpan: nil,
                temperament: nil,
                description: nil,
                image: nil
            ),

            Breed(
                id: "id",
                name: "name",
                origin: nil,
                lifeSpan: nil,
                temperament: nil,
                description: nil,
                image: nil
            ),

            Breed(
                id: "id2",
                name: "name",
                origin: nil,
                lifeSpan: nil,
                temperament: nil,
                description: nil,
                image: nil
            ),

            Breed(
                id: "id",
                name: nil,
                origin: nil,
                lifeSpan: nil,
                temperament: nil,
                description: nil,
                image: nil
            )
        ]

        let breedDetail = mapToBreedDetail(result: breeds, favorites: [])
        #expect(breedDetail.count == 2)
    }

    @Test func mapBreedToBreedDetailPersistance() {
        let breeds: [BreedDetail] = (1...5).map {
            BreedDetail(
                id: "id - \($0)",
                name: "name - \($0)",
                lifeSpan: "lifeSpan - \($0)",
                origin: "origin - \($0)",
                temperament: "temperament - \($0)",
                description: "description - \($0)",
                imageUrl: nil,
                isFavourite: false
            )
        }

        let breedDetail = mapToBreedDetailPersistance(breeds: breeds)
        #expect(breedDetail.count == 5)
    }
}
