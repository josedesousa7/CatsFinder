//
//  Breed.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

struct Breed: Codable {
    let id: String?
    let name: String?
    let origin: String?
    let lifeSpan: String?
    let temperament: String?
    let description: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case temperament = "temperament"
        case lifeSpan = "life_span"
        case origin = "origin"
        case description = "description"
        case image = "image"
    }
}

struct Image: Codable {
    let id: String?
    let url: String?
}
