//
//  SearchViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 21/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let pokemonList: [PokemonListItem]
    private let filteredList = BehaviorRelay<[PokemonListItem]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(pokemonList: [PokemonListItem]) {
        self.pokemonList = pokemonList
        super.init(nibName: nil, bundle: nil)
        self.filteredList.accept(pokemonList) // Default: Show all Pokemon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindSearch()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.placeholder = "Search Pokémon"
        searchBar.becomeFirstResponder() // Auto-focus search bar
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
    }
    
    private func bindSearch() {
        // Filter Pokemon list based on search query
        searchBar.rx.text.orEmpty
            .map { query in
                query.isEmpty ? self.pokemonList : self.pokemonList.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
            .bind(to: filteredList)
            .disposed(by: disposeBag)
        
        // Bind filtered Pokemon list to tableView
        filteredList
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                cell.textLabel?.text = item.name.capitalized
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPokemon = filteredList.value[indexPath.row]
        
        let detailVC = PokemonDetailViewController(pokemonURL: selectedPokemon.url)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
