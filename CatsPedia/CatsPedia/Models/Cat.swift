//
//  Cat.swift
//  CatsPedia
//
//  Created by José Marques on 07/11/2024.
//

import Foundation

struct Cat: Codable {
    let id: String?
    let url: String?
    let breeds: [Breed]
}
