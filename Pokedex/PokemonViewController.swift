//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 13.04.2023.
//

import UIKit

class PokemonViewController: UIViewController {
    let nameLabel = UILabel()
    let numberLabel = UILabel()
    let type1Label = UILabel()
    let type2Label = UILabel()
    let pokemonPicture = UIImageView()
    let activityIndicator = UIActivityIndicatorView()
    weak var pokemonDataTask: URLSessionDataTask?
    weak var pokemonImageTask: URLSessionTask?
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: pokemonPicture's parametrs creating
        pokemonPicture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pokemonPicture)
        pokemonPicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        pokemonPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pokemonPicture.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22).isActive = true
        pokemonPicture.widthAnchor.constraint(equalTo: pokemonPicture.heightAnchor).isActive = true
        
        //MARK: nameLabel's parametrs creating
        nameLabel.font = .boldSystemFont(ofSize: 25)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: pokemonPicture.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
        
        //MARK: numberLabel's parametrs creating
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //MARK: parametrs of typeLabels creating
        type1Label.translatesAutoresizingMaskIntoConstraints = false
        type2Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(type1Label)
        view.addSubview(type2Label)
        type1Label.topAnchor.constraint(equalTo: numberLabel.bottomAnchor).isActive = true
        type1Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        type2Label.topAnchor.constraint(equalTo: type1Label.bottomAnchor).isActive = true
        type2Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //MARK: activityIndicator's parametrs creating
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        activityIndicator.centerXAnchor.constraint(equalTo: pokemonPicture.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: pokemonPicture.centerYAnchor).isActive = true

        activityIndicator.startAnimating()
        
        self.pokemonDataTask = request(
            with: pokemon.url,
            model: PokemonData.self
        ) { [weak self] result in
            switch result {
            case .success(let list):
                self?.nameLabel.text = self?.pokemon.name.capitalized
                self?.numberLabel.text = String(format: "#%04d", list.id)
                self?.pokemonImageTask = self?.pokemonPicture.loadImage(from: list.sprites.front_default, completion: { [weak self] in
                    self?.activityIndicator.stopAnimating()
                })
                for typeEntry in list.types {
                    if typeEntry.slot == 1 {
                        self?.type1Label.text = typeEntry.type.name
                    } else if typeEntry.slot == 2 {
                        self?.type2Label.text = typeEntry.type.name
                    }
                }
            case .failure(let error):
                self?.nameLabel.text = "Oops, we can't find data on this Pokemon"
                self?.pokemonPicture.image = UIImage(named: "pokeball")
                self?.activityIndicator.stopAnimating()
                print(" \(self?.pokemon.name ?? "") \(error.localizedDescription)")
            }
        }
    }
    
    func preparePokemon(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    deinit{
        self.pokemonDataTask?.cancel()
        self.pokemonImageTask?.cancel()
    }
    
}


    
