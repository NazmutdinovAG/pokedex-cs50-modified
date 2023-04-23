//
//  ViewController.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 13.04.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var pokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request(
            with: "https://pokeapi.co/api/v2/pokemon?limit=151",
            model: PokemonList.self
        ) { [weak self] result in
            switch result {
            case .success(let list):
                self?.pokemon = list.results
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as! PokemonCell     
        cell.prepare(pokemon: pokemon[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

