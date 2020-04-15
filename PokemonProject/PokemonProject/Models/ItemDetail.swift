//
//  ItemDetail.swift
//  PokemonProject
//
//  Created by Mariana on 09/04/20.
//  Copyright © 2019 Mariana. All rights reserved.
//

import Foundation

// MARK: - Item
struct ItemDetail: Codable {
    let abilities: [AbilityElement]
    let gameIndices: [GameIndex]
    let height: Int
    let name: String
    let order: Int
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
   
     enum CodingKeys: String, CodingKey {
         case abilities
         case gameIndices = "game_indices"
         case height, name, order, sprites, stats, types, weight
     }
}

// MARK: - AbilityElement
struct AbilityElement: Codable {
    let ability: VersionClass
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - VersionClass
struct VersionClass: Codable {
    let name: String
    let url: String
}

// MARK: - GameIndex
struct GameIndex: Codable {
    let gameIndex: Int
    let version: VersionClass

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

// MARK: - Sprites
struct Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat, effort: Int
    let stat: VersionClass

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: VersionClass
}


