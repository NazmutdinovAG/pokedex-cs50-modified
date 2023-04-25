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
            with: "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0",
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonVC = storyboard?.instantiateViewController(withIdentifier: "pokemonSegue") as! PokemonViewController
        pokemonVC.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
        self.show(pokemonVC, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.indexPathForSelectedRow
    }

}

