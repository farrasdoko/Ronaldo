//
//  PokemonListResponse.swift
//  Ronaldo
//
//  Created by Doko Farras on 21/03/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonListItem]
    let next: String?
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
}
