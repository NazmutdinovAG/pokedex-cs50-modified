//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 18.04.2023.
//

import UIKit

class PokemonCell: UITableViewCell {
    let activityIndicator = UIActivityIndicatorView()
    let nameLabel = UILabel()
    let pokemonImage = UIImageView()
    weak var pokemonDataTask: URLSessionDataTask?
    weak var pokemonImageTask: URLSessionTask?
    
    func prepare(pokemon: Pokemon) {
        
        
        
        //MARK: pokemonImage's parametrs creating
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pokemonImage)
        pokemonImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pokemonImage.widthAnchor.constraint(equalTo: pokemonImage.heightAnchor).isActive = true
        pokemonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        
        //MARK: activityIndicator's parametrs creating
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: pokemonImage.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: pokemonImage.centerYAnchor).isActive = true
    
        //MARK: nameLabel's parametrs creating
        nameLabel.text = pokemon.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: pokemonImage.trailingAnchor, constant: 5).isActive = true
        
        
        self.pokemonDataTask = request(with: pokemon.url, model: PokemonData.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pokemonImageTask = self?.pokemonImage.loadImage(from: data.sprites.front_default, completion: { [weak self] in
                    self?.activityIndicator.stopAnimating()
                })
            case .failure(let error):
                self?.pokemonImage.image = UIImage(named: "pokeball")
                self?.activityIndicator.stopAnimating()
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

