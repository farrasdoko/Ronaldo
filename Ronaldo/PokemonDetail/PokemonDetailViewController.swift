//
//  PokemonDetailViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 21/03/25.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class PokemonDetailViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let pokemonURL: String
    private var pokemon: PokemonDetail?
    
    init(pokemonURL: String) {
        self.pokemonURL = pokemonURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        fetchPokemonDetails()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonDetailCell.self, forCellReuseIdentifier: "PokemonDetailCell")
    }
    
    private func fetchPokemonDetails() {
        AF.request(pokemonURL)
            .validate()
            .responseDecodable(of: PokemonDetail.self) { response in
                switch response.result {
                case .success(let pokemon):
                    self.pokemon = pokemon
                    self.tableView.tableHeaderView = self.createTableHeader()
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching Pokemon details: \(error.localizedDescription)")
                }
            }
    }
    
    private func createTableHeader() -> UIView {
        guard let pokemon = pokemon else { return UIView() }
        
        let headerView = PokemonDetailHeaderView()
        headerView.configure(with: pokemon)
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 250)
        
        return headerView
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Basic Info, Abilities, Moves
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pokemon = pokemon else { return 0 }
        switch section {
        case 0: return 3 // Basic info (height, weight, experience)
        case 1: return pokemon.abilities.count // Abilities
        case 2: return min(pokemon.moves.count, 5) // Show first 5 moves
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pokemon = pokemon else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDetailCell", for: indexPath) as! PokemonDetailCell
        
        let pokemonWeight = Double(pokemon.weight) / 10.0
        let pokemonHeight = Double(pokemon.height) / 10.0
        
        switch indexPath.section {
        case 0:
            let info = [
                "Height: \(pokemonHeight)m",
                "Weight: \(pokemonWeight)kg",
                "Base XP: \(pokemon.baseExperience)"
            ]
            cell.configure(text: info[indexPath.row])
        case 1:
            cell.configure(text: pokemon.abilities[indexPath.row].ability.name.capitalized)
        case 2:
            cell.configure(text: pokemon.moves[indexPath.row].move.name.capitalized)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Basic Info"
        case 1: return "Abilities"
        case 2: return "Moves"
        default: return nil
        }
    }
}
