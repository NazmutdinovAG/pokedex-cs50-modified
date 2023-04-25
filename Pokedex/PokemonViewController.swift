//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 13.04.2023.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var pokemonPicture: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var pokemonDataTask: URLSessionDataTask?
    weak var pokemonImageTask: URLSessionTask?
    
    var pokemon: Pokemon!
    
//    convenience init(pokemon: Pokemon) {
//        self.init()
//        self.pokemon = pokemon
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


    
