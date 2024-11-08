//
//  FavoriteBreed.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation

struct FavoriteBreed: Codable {
    let id: Int?
    let userId: String?
    let imageId: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case imageId = "image_id"
    }
}
