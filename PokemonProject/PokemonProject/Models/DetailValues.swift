//
//  SecondViewModel.swift
//  PokemonProject
//
//  Created by DetailViewController on 4/10/20.
//  Copyright © 2020 MarianaSouza. All rights reserved.
//

import Foundation

struct DetailValues {
    private(set) var name: String = String()
    private(set) var number: Int = Int()
    private(set) var height: Int = Int()
    private(set) var weight: Int = Int()
}

extension DetailValues {
    init(item: ItemDetail) {
        name = item.name
        number = item.order
        height = item.height
        weight = item.weight
    }
}

struct FormatedObjects {
    var sectionName : String!
    var sectionObjects : [VersionClass]!
}

struct Ability {
    private(set) var abilities: [VersionClass]?
}

extension Ability {
    init(ability: AbilityElement) {
        abilities = [ability.ability]
    }
}

struct Game {
    private(set) var gameIndex: Int?
    private(set) var version: [VersionClass]?
}

extension Game {
    init(game: GameIndex) {
        gameIndex = game.gameIndex
        version = [game.version]
    }
}

struct Sprite {
    private(set) var frontDefault: String = String()
}

extension Sprite {
    init(sprite: Sprites) {
        frontDefault = sprite.frontDefault
    }
}

struct Stats {
    private(set) var allStat: [VersionClass]?

}

extension Stats {
    init(stat: Stat) {
        allStat = [stat.stat]
    }
}

struct Type {
    private(set) var slot: Int?
    private(set) var alltype: [VersionClass]?
}

extension Type {
    init(type: TypeElement) {
        slot = type.slot
        alltype = [type.type]
    }
}


