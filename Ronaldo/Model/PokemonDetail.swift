//
//  PokemonDetail.swift
//  Ronaldo
//
//  Created by Doko Farras on 21/03/25.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let types: [PokemonTypeSlot]
    let abilities: [PokemonAbilitySlot]
    let stats: [PokemonStat]
    let sprites: PokemonSprites
    let moves: [PokemonMoveSlot]
    
    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, abilities, stats, sprites, moves
        case baseExperience = "base_experience"
    }
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonAbilitySlot: Codable {
    let ability: PokemonAbility
}

struct PokemonAbility: Codable {
    let name: String
}

struct PokemonStat: Codable {
    let baseStat: Int
    let stat: StatDetail
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatDetail: Codable {
    let name: String
}

struct PokemonSprites: Codable {
    let other: OtherSprites
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Moves
struct PokemonMoveSlot: Codable {
    let move: PokemonMove
}

struct PokemonMove: Codable {
    let name: String
}
