//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 18.04.2023.
//

import UIKit

class PokemonCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    weak var pokemonDataTask: URLSessionDataTask?
    weak var pokemonImageTask: URLSessionTask?
    
    func prepare(pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        self.pokemonDataTask = request(with: pokemon.url, model: PokemonData.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pokemonImageTask = self?.pokemonImage.loadImage(from: data.sprites.front_default, completion: { [weak self] in
                    self?.activityIndicator.stopAnimating()
                })
            case .failure(let error):
                print(" \(pokemon.name) \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        self.pokemonImageTask?.cancel()
        self.pokemonDataTask?.cancel()
        self.pokemonImage.image = nil
        self.activityIndicator.startAnimating()
    }
    
}

