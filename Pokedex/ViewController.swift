//
//  ViewController.swift
//  Pokedex
//
//  Created by Аскар Назмутдинов on 13.04.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var pokemon: [Pokemon] = []
    var firstRequestDataCount: Int?
    var pagination = true
    let limitContentOffset = 50
    
    override func viewWillAppear(_ animated: Bool) {
        if pokemon.isEmpty {
            request(with: "https://pokeapi.co/api/v2/pokemon?offset=\(pokemon.count)&limit=\(limitContentOffset)", model: PokemonList.self) { [weak self] result in
                switch result {
                case .success(let list):
                    self?.pokemon.append(contentsOf: list.results)
                    self?.tableView.reloadData()
                    self?.firstRequestDataCount = list.results.count
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard pagination else { return }
        let lastIndex = pokemon.count - 5
        
        if lastIndex == indexPath.row {
            request(with: "https://pokeapi.co/api/v2/pokemon?offset=\(pokemon.count)&limit=\(limitContentOffset)", model: PokemonList.self) { [weak self] result in
                switch result {
                case .success(let list):
                    self?.pokemon.append(contentsOf: list.results)
                    tableView.reloadData()
                    if let firstRequestDataCount = self?.firstRequestDataCount {
                        self?.pagination = list.results.count >= firstRequestDataCount ? true : false
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
