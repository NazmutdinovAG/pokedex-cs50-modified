//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 13.04.2023.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var type2Label: UILabel!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: pokemon.url) else { return }
        URLSession.shared.dataTask(with: url) { data, respone, error in
            guard let data = data else { return }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                DispatchQueue.main.async {
                    self.nameLabel.text = self.pokemon.name.capitalized
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        } else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
        
    }
}
