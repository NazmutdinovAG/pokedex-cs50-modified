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
    
    deinit{
        self.pokemonDataTask?.cancel()
        self.pokemonImageTask?.cancel()
    }
    
}

extension UIImageView {
    @discardableResult
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
    
