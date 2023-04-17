//
//  Pokemon.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 13.04.2023.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}


struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonPicture
}

struct PokemonType: Codable {
    let name: String
    let url: String
}


struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonPicture: Codable {
    let front_default: String
}


