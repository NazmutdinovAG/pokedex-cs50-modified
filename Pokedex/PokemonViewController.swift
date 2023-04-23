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
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        guard let url = URL(string: pokemon.url) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, respone, error in
            guard let data = data else { return }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async {
                    self?.nameLabel.text = self?.pokemon.name.capitalized
                    self?.numberLabel.text = String(format: "#%04d", pokemonData.id)
                    self?.pokemonPicture.loadImage(from: pokemonData.sprites.front_default, completion: {
                        self?.activityIndicator.stopAnimating()
                    })?.resume()
                    
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
    
    func loadImage(from stringURL: String, completion: @escaping () -> Void = {}) -> URLSessionDataTask? {
        guard let url = URL(string: stringURL) else { return nil }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.image = image
                completion()
            }
        }
        task.resume()
        return task
    }
    
}
    
