//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 18.04.2023.
//

import UIKit

class PokemonCell: UITableViewCell {
    
    func prepare(pokemon: Pokemon) {
        self.textLabel?.text = pokemon.name
        if let url = URL(string: pokemon.url) {
            URLSession.shared.dataTask(with: url) { data, respone, error in
                guard let data = data else { return }
                do {
                    let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView?.loadImage(from: pokemonData.sprites.front_default)
                    }
                }
                catch let error {
                    print("\(error)")
                }
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        self.imageView?.image = nil
    }

}

