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
    
    var pokemon: Pokemon!
    var pokemonImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: pokemon.url) else { return }
        URLSession.shared.dataTask(with: url) { data, respone, error in
            guard let data = data else { return }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.nameLabel.text = self?.pokemon.name.capitalized
                    self?.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    self?.pokemonPicture.loadImage(from: pokemonData.sprites.front_default)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self?.type1Label.text = typeEntry.type.name
                        } else if typeEntry.slot == 2 {
                            self?.type2Label.text = typeEntry.type.name
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

extension UIImageView {
    func loadImage(from stringURL: String) {
        guard let url = URL(string: stringURL) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard data != nil else { return }
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
}
