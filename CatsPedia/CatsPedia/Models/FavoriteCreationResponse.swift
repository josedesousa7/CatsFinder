//
//  FavoriteResponse.swift
//  CatsPedia
//
//  Created by José Marques on 08/11/2024.
//

import Foundation

struct FavoriteCreationResponse: Codable {
    let message: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case message = "message"
    }
}
