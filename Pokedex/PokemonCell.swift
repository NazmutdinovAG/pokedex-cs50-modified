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
        guard let url = URL(string: pokemon.url) else { return }
        self.pokemonDataTask = URLSession.shared.dataTask(with: url) {[weak self] data, respone, error in
            guard let data = data else { return }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                self?.pokemonImageTask = self?.pokemonImage.loadImage(from: pokemonData.sprites.front_default, completion: {[weak self] in
                    self?.activityIndicator.stopAnimating()
                })
                self?.pokemonImageTask?.resume()
            }
            catch let error {
                print("\(error)")
            }
        }
        self.pokemonDataTask?.resume()
    }
    
    override func prepareForReuse() {
        self.pokemonImageTask?.cancel()
        self.pokemonDataTask?.cancel()
        self.pokemonImage.image = nil
        self.activityIndicator.startAnimating()
    }
    
}

