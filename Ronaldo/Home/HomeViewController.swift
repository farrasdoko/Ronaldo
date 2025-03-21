//
//  HomeViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import SnapKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import MBProgressHUD

class HomeViewController: UIViewController {
    
    var itemInfo: IndicatorInfo = "Home"
    
    private let searchBar = UISearchBar()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.placeholder = "Search Pokémon"
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        
        // Open SearchViewController when the search bar is tapped
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let searchVC = SearchViewController(pokemonList: self.viewModel.pokemonList.value)
                let navController = UINavigationController(rootViewController: searchVC)
                self.present(navController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.pokemonList
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                cell.textLabel?.text = item.name.capitalized
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

}

extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPokemon = viewModel.pokemonList.value[indexPath.row]
        
        let detailVC = PokemonDetailViewController(pokemonURL: selectedPokemon.url)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
